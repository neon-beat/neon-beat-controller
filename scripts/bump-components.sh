#!/bin/bash

set -e

# Careful: this uses the unauthenticated Github API, which tolerates only
# up to 60  requests per hour

SCRIPT_DIR=$(dirname "$(realpath $0)")
TOP_DIR=${SCRIPT_DIR}/..

declare -A COMPONENTS
COMPONENTS["neon-beat-backend"]="neon-beat-back"
COMPONENTS["neon-beat-game-frontend"]="neon-beat-game-front"
COMPONENTS["neon-beat-admin-frontend"]="neon-beat-admin-front"

for c in ${!COMPONENTS[@]}
do
	echo "Searching for ${c} latest version"
	raw_version=$(curl -s https://api.github.com/repos/neon-beat/${COMPONENTS[$c]}/releases/latest|jq -r '.tag_name')
	if [ $? -ne 0 ]
	then
		echo "Can not get latest version for ${c}"
		continue
	fi
	if [ ${raw_version} != "null" ]
	then
		# Strip tag prefix
		version=${raw_version#v}
		# Build version field in .mk file
		version_field=$(echo "${c//-/_}" | awk '{print toupper($0)"_VERSION"}')
		# Compute .mk and .hash file locations
		mk_file=${TOP_DIR}/package/${c}/${c}.mk
		hash_file=${TOP_DIR}/package/${c}/${c}.hash
		# Read current version
		current_version=$(grep -e "^${version_field}" ${mk_file}|cut -d '=' -f 2|sed 's/^[ \t]//g')
		if [ "${current_version}" != "${version}" ]
		then
			echo "Upgrade component ${c} from ${current_version} to ${version}"
			archive="${c}.tar.gz"
			curl -so ${archive} https://codeload.github.com/neon-beat/${COMPONENTS[${c}]}/tar.gz/refs/tags/${raw_version}
			new_sha256=$(sha256sum ${archive}|cut -d ' ' -f 1)
			sed -i "s/^\(${version_field} *= *\).*/\1${version}/" ${mk_file}
			sed -i "s/sha256  [0-9a-f].*  ${c}-${current_version}\(.*\)$/sha256  ${new_sha256}  ${c}-${version}\1/" ${hash_file}
			rm -rf ${archive}
		fi
	fi
done
