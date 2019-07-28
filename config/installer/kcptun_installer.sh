!/bin/bash

    cd ${DIR_TMP}
    tar zxf ${KCPTUN_FILE}-${KCPTUN_VER}.tar.gz
    mv server_linux_amd64 ${KCPTUN_DIR}
    if [ $? -eq 0 ]; then
        echo -e "\033[32m[INFO] kcptun Successful installation.."
    else
        echo
        echo -e "\033[31m[ERROR] kcptun installation failed.."
        echo
        exit 1
    fi
