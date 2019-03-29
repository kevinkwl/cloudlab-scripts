source ./config.sh

mkdir -p ${MOD_PATH}
cd ${LINUX_SRC}
make -j`nproc` && make INSTALL_MOD_PATH=${MOD_PATH} modules_install -j`nproc`

cd -
