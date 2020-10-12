#![no_std]          //  Don't link with standard Rust library, which is not compatible with embedded systems

extern crate cortex_m;  //  Declare the external library cortex_m

use core::panic::PanicInfo;     //  Import the PanicInfo type which is used by panic() below
use cortex_m::asm::bkpt;        //  Import the cortex_m assembly function to inject breakpoint

#[no_mangle]                     //  Don't mangle the name "main"
pub extern "C" fn main() -> ! {  //  Declare extern "C" because it will be called by Mynewt

    //  Main event loop
    loop {                            //  Loop forever...
    }
    //  Never comes here.
}

///  This function is called on panic, like an assertion failure. We display the filename and line
///  number and pause in the debugger. From https://os.phil-opp.com/freestanding-rust-binary/
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    //  Pause in the debugger.
    bkpt();
    //  Loop forever so that device won't restart.
    loop {}
}
