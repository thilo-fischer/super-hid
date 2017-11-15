// Defines the data structures to be transferred via I2C

// Keep in syc with lib/super-hid/output/protocol_hid-api-cmds.rb !!

struct sCmd {

  // Bit 0 to 4: device type: keyboard, mouse, absolute mouse, gamepad, ...
  // Value as defined by eDevType
 unsigned int dev_type : 5;

  // Bit 5 to 7; device specific: operation to perform; key press/release, mouse button press/release, mouse move, ...
  // Value as defined by eKbdOpcodes, eMouseOpcodes, ...
  unsigned int op_code : 3;

  // following bytes: device and operation specific values
  union uOperationParameters {
    // OP_KBD_BEGIN, OP_KBD_REL_ALL, OP_KBD_END, OP_MOUSE_BEGIN, OP_MOUSE_END
    struct {} empty;
    // OP_KBD_PRESS, OP_KBD_RELEASE
    struct {
      uint8_t keycode;
    } kbd_key;
    // OP_MOUSE_PRESS, OP_MOUSE_RELEASE
    struct {
      uint8_t button;
    } mouse_btn;
    // OP_MOUSE_MOVE
    struct {
      int8_t x;
      int8_t y;
    } mouse_mv;
    // OP_MOUSE_WHEEL
    struct {
      int8_t val;
    } mouse_wheel;
    // ...
  } param;
};


enum eDevType {
  DEV_INVALID    = 0x00,
  DEV_KBD        = 0x01,
  DEV_KBD_BOOT   = 0x02,
  DEV_KBD_NKRO   = 0x03,
  DEV_MOUSE      = 0x04,
  DEV_MOUSE_BOOT = 0x05,
  DEV_MOUSE_ABS  = 0x06,
  DEV_GAMEPAD    = 0x07,
  DEV_CONSUMER   = 0x08,
  DEV_SYSTEM     = 0x09,
  DEV_RAW_HID    = 0x1F
};


enum eKbdOpcodes {
  OP_KBD_INVALID   = 0,
  OP_KBD_BEGIN     = 1, // Keyboard begin
  OP_KBD_PRESS     = 2, // Keyboard press
  OP_KBD_RELEASE   = 3, // Keyboard release
  OP_KBD_REL_ALL   = 4, // Keyboard release_all
  OP_KBD_END       = 7  // Keyboard end
};
enum eMouseOpcodes {
  OP_MOUSE_INVALID = 0,
  OP_MOUSE_BEGIN   = 1, // Mouse begin
  OP_MOUSE_MOVE    = 2, // Mouse move
  OP_MOUSE_PRESS   = 3, // Mouse press
  OP_MOUSE_RELEASE = 4, // Mouse release
  OP_MOUSE_WHEEL   = 5, // Mouse wheel
  OP_MOUSE_END     = 7  // Mouse end
};
// ...

