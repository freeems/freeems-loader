# /* FreeEMS-Loader- the open source s19 loader with special features for FreeEMS
# *
# * Copyright (C) 2008-2011 by Sean Keys <skeys@powerefi.com>
# *
# * This file is part of the FreeEMS-Loader project.
# *
# * FreeEMS-Loader software is free software: you can redistribute it and/or modify
# * it under the terms of the GNU General Public License as published by
# * the Free Software Foundation, either version 3 of the License, or
# * (at your option) any later version.
# *
# * FreeEMS-Loader software is distributed in the hope that it will be useful,
# * but WITHOUT ANY WARRANTY; without even the implied warranty of
# * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# * GNU General Public License for more details.
# *
# * You should have received a copy of the GNU General Public License
# * along with any FreeEMS-Loader software.  If not, see http://www.gnu.org/licenses/
# *
# * We ask that if you make any changes to this file you email them upstream to
# * us at info(at)powerefi(dot)com or, even better, fork the code on github.com!
# *
# * Thank you for choosing FreeEMS-Loader to load your firmware!
# *
# */
TEMPLATE = app
TARGET = FreeEMS-Loader
QMAKE_CXXFLAGS *= -Wall
QMAKE_CXXFLAGS *= -Werror
QMAKE_CXXFLAGS_DEBUG += -pg
QMAKE_LFLAGS_DEBUG += -pg
CONFIG *= qt \
    warn_on \
    thread \
    release \
    debug
QT *= core \
    gui

# xml \
# xmlpatterns \
# network \
# opengl
HEADERS += inc/about.h \
    inc/freeems_loader.h \
    inc/sRecord.h \ # inc/serialPort.h \
    inc/redirector.h \
    inc/parsing.h \
    inc/comms.h \
    inc/loaderTypes.h
SOURCES += freeemsLoader.cpp \
    main.cpp \ # serialPort.cpp \
    sRecord.cpp \
    parsing.cpp \
    comms.cpp \
    types.cpp \
    about.cpp
FORMS *= freeemsLoader.ui \
    about.ui
RESOURCES += resource-root.qrc
CONFIG(debug, debug|release):
else { 
    DEFINES += QT_NO_WARNING_OUTPUT \
        QT_NO_DEBUG_OUTPUT
    message("Building Release Version")
}

# Cross compilation
win32-x-g++ { 
    message("Crosscompiling on Unix to Windows")
    QMAKE_CXXFLAGS -= -Werror
}

# Straight Mac-OS (OS-X)
mac { 
    message("Mac OS-X Build")
    unix:INCLUDEPATH *= /opt/local/include
}

# Straight Linux
linux-g++ { 
    message("Straight Linux Build")
    unix:INCLUDEPATH += $$quote(/usr/local/include/)
    unix:LIBS += $$quote(/usr/local/lib/libSerialIO.so)
    DEFINES += GIT_HASH=$$system(git log -n 1 --pretty=format:%H)
}

# Native Windows Build
win32 { 
    message("Straight compile on windows (seank only)")
    unix:INCLUDEPATH *= /usr/local/include/
    DEFINES += GIT_HASH=$$system(git log -n 1 --pretty=format:%H)
    LIBS += -L/usr/local/win32/lib/SerialIO0.dll
    win32:LIBS *= -Lc:/mingw/lib \
        -lwsock32
}
