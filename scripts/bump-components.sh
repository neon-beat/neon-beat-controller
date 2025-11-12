#!/bin/bash

set -e

# Careful: this uses the unauthenticated Github API, which tolerates only
# up to 60  requests per hour

SCRIPT_DIR=$(dirname "$(realpath $0)")
TOP_DIR=${SCRIPT_DIR}/..
CARGO=${TOP_DIR}/output/host/bin/cargo

declare -A COMPONENTS
COMPONENTS["neon-beat-backend"]="neon-beat-back"
COMPONENTS["neon-beat-game-frontend"]="neon-beat-game-front"
COMPONENTS["neon-beat-admin-frontend"]="neon-beat-admin-front"

if [ ! -f ${CARGO} ]
then
	echo "You need cargo-host to be built and installed in buildroot host dir"
	exit 1
fi

# For cargo packages, buildroot includes the vendored dependencies in the
# SHA256 sum, so to get the updated sum, we need to:
# - uncompress the downloaded archive
# - vendor the deps inside it (with host-cargo from BR)
# - re-tar/re-compress it
compute_vendored_component_sha256() {
	ARCHIVE="${1}.tar.gz"
	WORKDIR="$(echo ${2}|cut -d '.' -f 1)-${3}"
	tar xzvf ${ARCHIVE} -C /tmp > /dev/null
	pushd "/tmp/${WORKDIR}" > /dev/null
	mkdir .cargo
	${CARGO} vendor --locked VENDOR > .cargo/config.toml
	find . -not -type d > /tmp/files.list
	LC_ALL=C sort < /tmp/files.list > /tmp/files_sorted.list
	tar -cf - --transform="s#^\./#${WORKDIR}/#S" \
		--numeric-owner --owner=0 --group=0 \
		--pax-option=delete=atime,delete=ctime,delete=mtime,exthdr.name=%d/PaxHeaders/%f \
		--mode='go=u,go-w' --format=posix -T /tmp/t-sorted.list > \
		/tmp/${1}.tar > /dev/null
	popd > /dev/null
	gzip -6 -n < "/tmp/${1}.tar" > "/tmp/${ARCHIVE}" 2>/dev/null

	echo $(sha256sum "/tmp/${ARCHIVE}"|cut -d ' ' -f 1)
}

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
			if [ ${c} == "neon-beat-backend" ]
			then
				new_sha256=$(compute_vendored_component_sha256 ${c} ${COMPONENTS[${c}]} ${version})
			else
				new_sha256=$(sha256sum ${archive}|cut -d ' ' -f 1)
			fi
			echo "New sha256 sum: ${new_sha256}"
			sed -i "s/^\(${version_field} *= *\).*/\1${version}/" ${mk_file}
			sed -i "s/sha256  [0-9a-f].*  ${c}-${current_version}\(.*\)$/sha256  ${new_sha256}  ${c}-${version}\1/" ${hash_file}
			rm -rf ${archive}
		fi
	fi
done
