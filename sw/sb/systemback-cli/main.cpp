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

#include "systemback-cli.hpp"

int main(int argc, char *argv[])
{
    if(sb::dbglev == sb::Alldbg) sb::dbglev = sb::Nulldbg;
    QCoreApplication a(argc, argv);
    sb::ldtltr();
    systemback c;

    QTimer::singleShot(0, &c,
#if QT_VERSION < QT_VERSION_CHECK(5, 4, 0)
        SLOT(main())
#else
        &systemback::main
#endif
        );

    uchar rv(a.exec());
    return rv;
}