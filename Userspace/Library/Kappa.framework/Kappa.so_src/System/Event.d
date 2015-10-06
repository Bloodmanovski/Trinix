﻿/**
 * Copyright (c) 2014-2015 Trinix Foundation. All rights reserved.
 * 
 * This file is part of Trinix Operating System and is released under Trinix
 * Public Source Licence Version 1.0 (the 'Licence'). You may not use this file
 * except in compliance with the License. The rights granted to you under the
 * License may not be used to create, or enable the creation or redistribution
 * of, unlawful or unlicensed copies of an Trinix operating system, or to
 * circumvent, violate, or enable the circumvention or violation of, any terms
 * of an Trinix operating system software license agreement.
 * 
 * You may obtain a copy of the License at
 * https://github.com/Bloodmanovski/Trinix and read it before using this file.
 * 
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 * 
 * Contributors:
 *      Matsumoto Satoshi <satoshi@gshost.eu>
 */

module System.Event;

import System;


class Event(T) {  //struct maybe??
    //TODO: list

    this() {
        //new list
    }

    ~this() {
        //delete list
    }

    void opCall(object sender, EventArgs e) {
        //foreach (x; m_list)
        //x(sender, e)l
    }

    void opOpAssign(string TOp)(T event) if (TOp == "+") {
        //if (!m_list.Contains(event))
        //m_list.Add(event);
    }

    void opOpAssign(string TOp)(T event) if (TOp == "-") {
        //m_list.Remove(event);
    }
}

unittest {
    class test {
        Event!EventHandler events = new Event!EventHandler();


        this() {
            event += &test_onEvent;

            event(EventArgs.Empty);
        }




        void test_OnEvent(object sender, EventArgs e) {
            //caled by event.opCall
        }
    }
}