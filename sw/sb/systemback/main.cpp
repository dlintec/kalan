/*
 * Copyright(C) 2014-2016, Krisztián Kende <nemh@freemail.hu>
 *
 * This file is part of Systemback.
 *
 * Systemback is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * Systemback is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Systemback. If not, see <http://www.gnu.org/licenses/>.
 */

#include "systemback.hpp"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    sb::ldtltr();

    uchar rv([&a] {
            if(qgetenv("XAUTHORITY").startsWith("/home/") && ! getuid())
            {
                sb::error("\n " % sb::tr("Unsafe X Window authorization!") % "\n\n " % sb::tr("Please do not use 'sudo' command.") % "\n\n");
                return 1;
            }

            systemback w;
            w.fscrn ? w.showFullScreen() : w.show();
            return a.exec();
        }());

    return rv;
}
