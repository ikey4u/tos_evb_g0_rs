#! /usr/bin/env bash
# Author: ikey4u

set -e

ROOTDIR=$(git rev-parse --show-toplevel)
[[ ! -e $ROOTDIR ]] && echo "[x] Cannot ROOTDIR" && exit 1

BUILD_DIR=$ROOTDIR/build
[[ -e $BUILD_DIR ]] && rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR && cd $BUILD_DIR
cmake .. && make
cd $ROOTDIR

ROM=$ROOTDIR/build/mqtt_iot_explorer_tc_ch20_oled
[[ -e $ROM ]] && rm $ROM

RUST_APP_DEST=$ROOTDIR/build/librustapp.a
[[ -e $RUST_APP_DEST ]] && rm $RUST_APP_DEST

RUST_CORE_DEST=$ROOTDIR/build/librustcore.a
[[ -e $RUST_CORE_DEST ]] && rm $RUST_CORE_DEST

cd $ROOTDIR/app
RUSTFLAGS="-L $BUILD_DIR" cargo build -v
cd $ROOTDIR

RUST_OBJ_DIR=$ROOTDIR/app/target/thumbv6m-none-eabi/debug/deps
[[ ! -e $RUST_OBJ_DIR ]] && echo "[x] Cannot find RUST_OBJ_DIR" && exit 1

RUST_OBJ_TMPDIR=$ROOTDIR/build/rustobj
[[ -e  $RUST_OBJ_TMPDIR ]] && rm -rf $RUST_OBJ_TMPDIR
mkdir -p $RUST_OBJ_TMPDIR && cd $RUST_OBJ_TMPDIR
for rustobj in $RUST_OBJ_DIR/*.rlib
do
    arm-none-eabi-ar x $rustobj
done
arm-none-eabi-ar x $BUILD_DIR/libtosglue.a
mv tosglue.c.obj tosglue.o
RUST_APP_SRC=$RUST_OBJ_TMPDIR/$(basename -z ${RUST_APP_DEST})
arm-none-eabi-ar r $(basename ${RUST_APP_SRC}) *.o
cp $RUST_APP_SRC $RUST_APP_DEST
touch $RUST_APP_DEST
# arm-none-eabi-objdump -t -S --demangle --line-numbers --wide ${RUST_APP_SRC} > $ROOTDIR/rustapp-demangle.txt 2>&1
cd $ROOTDIR

RUST_THUMBV6M_SYSROOT=$(rustc --print sysroot --target thumbv6m-none-eabi)
RUST_CORE_SRC=$(ls -1 $RUST_THUMBV6M_SYSROOT/lib/rustlib/thumbv6m-none-eabi/lib/libcore-*.rlib)
cp $RUST_CORE_SRC $RUST_CORE_DEST

cd $BUILD_DIR && make

make flash
