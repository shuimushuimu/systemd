#!/bin/bash
set -e
TEST_DESCRIPTION="test StandardOutput=file:"

. $TEST_BASE_DIR/test-functions

test_setup() {
    create_empty_image_rootdir

    (
        LOG_LEVEL=5
        eval $(udevadm info --export --query=env --name=${LOOPDEV}p2)

        setup_basic_environment
        mask_supporting_services
        inst_binary cmp

        # setup the testsuite service
        cat >$initdir/etc/systemd/system/testsuite.service <<EOF
[Unit]
Description=Testsuite service

[Service]
ExecStart=/testsuite.sh
Type=oneshot
EOF
        cp testsuite.sh $initdir/

        setup_testsuite
    )
    setup_nspawn_root
}

do_test "$@"
