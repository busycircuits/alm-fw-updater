#!/bin/sh

APPNAME="ALM Firmware Updater"
APPBUNDLE=${APPNAME}.app
APPBUNDLECONTENTS=${APPBUNDLE}/Contents
APPBUNDLEEXE=${APPBUNDLECONTENTS}/MacOS
APPBUNDLERESOURCES=${APPBUNDLECONTENTS}/Resources
APPBUNDLEICON=${APPBUNDLECONTENTS}/Resources
DFUBIN=/usr/local/bin/dfu-util
QTBINPATH=/usr/local/opt/qt5/bin

echo "Creating ${APPBUNDLE}"

cp macosx/icon.png "macosx/${APPNAME}Icon.png"

rm -rf "macosx/${APPNAME}.iconset"
mkdir "macosx/${APPNAME}.iconset"

sips -z 16 16     "macosx/${APPNAME}Icon.png" --out "macosx/${APPNAME}.iconset/icon_16x16.png"
sips -z 32 32     "macosx/${APPNAME}Icon.png" --out "macosx/${APPNAME}.iconset/icon_16x16@2x.png"
sips -z 32 32     "macosx/${APPNAME}Icon.png" --out "macosx/${APPNAME}.iconset/icon_32x32.png"
sips -z 64 64     "macosx/${APPNAME}Icon.png" --out "macosx/${APPNAME}.iconset/icon_32x32@2x.png"
sips -z 128 128   "macosx/${APPNAME}Icon.png" --out "macosx/${APPNAME}.iconset/icon_128x128.png"
sips -z 256 256   "macosx/${APPNAME}Icon.png" --out "macosx/${APPNAME}.iconset/icon_128x128@2x.png"
sips -z 256 256   "macosx/${APPNAME}Icon.png" --out "macosx/${APPNAME}.iconset/icon_256x256.png"
sips -z 512 512   "macosx/${APPNAME}Icon.png" --out "macosx/${APPNAME}.iconset/icon_256x256@2x.png"
sips -z 512 512   "macosx/${APPNAME}Icon.png" --out "macosx/${APPNAME}.iconset/icon_512x512.png"

cp "macosx/${APPNAME}Icon.png" "macosx/${APPNAME}.iconset/icon_512x512@2x.png"
iconutil -c icns -o "macosx/${APPNAME}.icns" "macosx/${APPNAME}.iconset"
rm -r "macosx/${APPNAME}.iconset"

rm -rf "${APPBUNDLE}"
mkdir "${APPBUNDLE}"
mkdir "${APPBUNDLE}/Contents"
mkdir "${APPBUNDLE}/Contents/MacOS"
mkdir "${APPBUNDLE}/Contents/Resources"
mkdir "${APPBUNDLE}/Contents/libs"
cp macosx/Info.plist "${APPBUNDLECONTENTS}/"
cp macosx/PkgInfo "${APPBUNDLECONTENTS}/"
cp "macosx/${APPNAME}.icns" "${APPBUNDLEICON}/"
cp alm-fw-update "${APPBUNDLEEXE}/${APPNAME}"

#bundle dfu-util
cp ${DFUBIN} "${APPBUNDLE}/Contents/MacOS/"
chmod a+rw "${APPBUNDLE}/Contents/MacOS/dfu-util"
cd "${APPBUNDLE}"
dylibbundler -od -b -x ./Contents/MacOS/dfu-util -d ./Contents/libs/
cd ..

rm -fr "${APPNAME}".dmg

#finally qt & spit out dmg
/usr/local/opt/qt5/bin/macdeployqt "${APPBUNDLE}" -verbose=2 -dmg

