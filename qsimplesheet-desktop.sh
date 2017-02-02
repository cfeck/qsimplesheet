#!/bin/sh
cat <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=QSimpleSheet
GenericName=Spreadsheet
Comment=Simple spreadsheet
TryExec=$1/bin/qsimplesheet
Exec=$1/bin/qsimplesheet &
Categories=Application;Office;Spreadsheet;
Icon=$1/share/icons/applicationIcon.png
EOF
