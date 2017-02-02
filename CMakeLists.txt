# set project's name
PROJECT( QSimpleSheet )

CMAKE_MINIMUM_REQUIRED(VERSION 2.4.0)

# with SET() command you can change variables or define new ones
# here we define qsimplesheet_SRCS variable that contains a list of all .cpp files
# note that we don't need \ at the end of line
SET( QSimpleSheet_SRCS
./src/Calculator.cpp
./src/Cell.cpp
./src/Commands.cpp
./src/Graphic.cpp
./src/ItemDelegate.cpp
./src/MainWindow.cpp
./src/PictureGraphic.cpp
./src/QSimplesheet.cpp
./src/Table.cpp
./src/Dialogs/FindDialog.cpp
./src/Dialogs/FunctionListDialog.cpp
./src/Dialogs/GraphicPropertiesDialog.cpp
./src/Dialogs/InsertRCDialog.cpp
./src/Dialogs/MySpinBox.cpp
./src/Dialogs/NewFileDialog.cpp
./src/Dialogs/SortDialog.cpp
)

# another list, this time it includes all header files that should be treated with moc
SET( QSimpleSheet_MOC_HDRS
./src/Calculator.h
./src/Cell.h
./src/Commands.h
./src/Graphic.h
./src/ItemDelegate.h
./src/MainWindow.h
./src/PictureGraphic.h
./src/QSimplesheet.h
./src/Table.h
./src/Dialogs/FindDialog.h
./src/Dialogs/FunctionListDialog.h
./src/Dialogs/GraphicPropertiesDialog.h
./src/Dialogs/InsertRCDialog.h
./src/Dialogs/MySpinBox.h
./src/Dialogs/NewFileDialog.h
./src/Dialogs/SortDialog.h
)

# some .ui files
SET( QSimpleSheet_UIS
./src/Dialogs/FindDialog.ui
./src/Dialogs/FunctionListDialog.ui
./src/Dialogs/GraphicPropertiesDialog.ui
./src/Dialogs/InsertRCDialog.ui
./src/Dialogs/NewFileDialog.ui
./src/Dialogs/SortDialog.ui
)

# and finally an resource file
SET( QSimpleSheet_RCS
     ./src/resources.qrc
)
  

# compiling flags
ADD_DEFINITIONS( -Wall -O2 -g)
  
# by default only QtCore and QtGui modules are enabled
# other modules must be enabled like this:
SET( QT_USE_QT3SUPPORT TRUE )   
SET( QT_USE_QTXML TRUE )
  
# this command finds Qt4 libraries and sets all required variables
# note that it's Qt4, not QT4 or qt4
FIND_PACKAGE( Qt4 REQUIRED )
  
# add some useful macros and variables
# (QT_USE_FILE is a variable defined by FIND_PACKAGE( Qt4 ) that contains a path to CMake script)
INCLUDE( ${QT_USE_FILE} )
  
# this command will generate rules that will run rcc on all files from qsimplesheet_RCS
# in result qsimplesheet_RC_SRCS variable will contain paths to files produced by rcc
QT4_ADD_RESOURCES( QSimpleSheet_RC_SRCS ${QSimpleSheet_RCS} )

# this will run uic on .ui files:
QT4_WRAP_UI( QSimpleSheet_UI_HDRS ${QSimpleSheet_UIS} )

# and finally this will run moc:
QT4_WRAP_CPP( QSimpleSheet_MOC_SRCS ${QSimpleSheet_MOC_HDRS} )

# we need this to be able to include headers produced by uic in our code
# (CMAKE_BINARY_DIR holds a path to the build directory, while INCLUDE_DIRECTORIES() works just like INCLUDEPATH from qmake)
INCLUDE_DIRECTORIES( ${CMAKE_BINARY_DIR} src src/Dialogs)

# here we instruct CMake to build "qsimplesheet" executable from all of the source files
ADD_EXECUTABLE( qsimplesheet ${QSimpleSheet_SRCS} ${QSimpleSheet_MOC_SRCS} ${QSimpleSheet_RC_SRCS} ${QSimpleSheet_UI_HDRS} )

# last thing we have to do is to tell CMake what libraries our executable needs,
# luckily FIND_PACKAGE prepared QT_LIBRARIES variable for us:
TARGET_LINK_LIBRARIES( qsimplesheet ${QT_LIBRARIES} )


if( UNIX AND NOT APPLE )
   if( NOT DESKTOP_ENTRY )
      set( DESKTOP_ENTRY qsimplesheet.desktop )
   endif( NOT DESKTOP_ENTRY )
   
   add_custom_command( OUTPUT ${DESKTOP_ENTRY}
      COMMAND touch ${DESKTOP_ENTRY}
      COMMAND sh ${QSimpleSheet_SOURCE_DIR}/qsimplesheet-desktop.sh ${CMAKE_INSTALL_PREFIX} >${DESKTOP_ENTRY}
      DEPENDS qsimplesheet-desktop.sh
      COMMENT "Generating desktop entry file"
      )
   add_custom_target( DESKTOP_ENTRY_FILE ALL
      DEPENDS ${DESKTOP_ENTRY}
      )

   set( APP_ICON src/images/applicationIcon.png )
endif( UNIX AND NOT APPLE )

if( NOT DESKTOP_ENTRY_PATH )
  set( DESKTOP_ENTRY_PATH ${CMAKE_INSTALL_PREFIX}/share/applications )
endif( NOT DESKTOP_ENTRY_PATH )

if(UNIX AND NOT APPLE)
   install( FILES ${APP_ICON} DESTINATION share/icons )
   install( FILES ${QSimpleSheet_BINARY_DIR}/${DESKTOP_ENTRY} DESTINATION ${DESKTOP_ENTRY_PATH} )
endif(UNIX AND NOT APPLE)


install(TARGETS qsimplesheet DESTINATION bin)
