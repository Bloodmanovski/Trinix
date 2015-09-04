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

module ObjectManager.DeviceManager;

import VFSManager;
import Architecture;


struct InterruptStack {
align(1):
    ulong R15, R14, R13, R12, R11, R10, R9, R8;
    ulong RBP, RDI, RSI, RDX, RCX, RBX, RAX;
    ulong IntNumber, ErrorCode;
    ulong RIP, CS, Flags, RSP, SS;
}

enum DeviceType {
    Null,
    Misc,
    Terminal,
    Video,
    Audio,
    Disk,
    Input,
    Network,
    Filesystem
}

enum DeviceCommonCall {
    // Return DeviceType
    Type,

    // Return unique identifier for each method
    // eg. "com.trinix.VFSManager.FSNode"
    Identifier,

    // Return 8-digits (2 major, 2 minor, 4 patch) version 
    Version,

    // Return array of found lookups
    Lookup,

    // Translate unique identifier of each call to his ID
    Translate
}

abstract final class DeviceManager {
    private __gshared void function(ref InterruptStack stack) m_handlers[48];
    __gshared DirectoryNode DevFS;

    static void RequestIRQ(void function(ref InterruptStack) handle, int intNumber) {
        if (intNumber < 16)
            m_handlers[intNumber + 32] = handle;
    }

    static void RequestISR(void function(ref InterruptStack) handle, int intNumber) {
        if (intNumber < 32)
            m_handlers[intNumber] = handle;
    }

    import Core;
    static void Handler(ref InterruptStack stack) {
        if (stack.IntNumber < 48) {
            if (m_handlers[stack.IntNumber] !is null) {
                m_handlers[stack.IntNumber](stack);
            }
        }
    }

    static void EOI(int irqNumber) {
        if (irqNumber >= 8)
            Port.Write(0xA0, 0x20);
        
        Port.Write(0x20, 0x20);
    }
}