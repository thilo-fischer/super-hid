// Defines the data structures to be transferred via I2C

struct sCmd {

  // Bit 0 to 2: device type: keyboard, mouse, absolute mouse, gamepad, ...
  // Value as defined by eDevType
 unsigned int dev_type : 3;

  // Bit 3 to 4; device specific: variant; for keyboard device e.g. BootKeyboard, ImprovedKeyboard, NKRO-Keyboard ...
  // Value as defined by eKbdVariant, eMouseVariant, eMiscVariant
  unsigned int dev_variant : 2;

  // Bit 5 to 7; device specific: operation to perform; key press/release, mouse button press/release, mouse move, ...
  // Value as defined by eKbdOpcodes, eMouseOpcodes, ...
  unsigned int op_code : 3;

  // following bytes: device and operation specific values
  union uOperationParameters {
    struct {
      uint8_t keycode;
    } kbd_key;
    struct {
      uint8_t button;
    } mouse_btn;
    struct {
      int8_t x;
      int8_t y;
    } mouse_mv;
    struct {
      int8_t val;
    } mouse_wheel;
    // ...
  } data;
};


enum eDevType {
  DEV_INVALID   = 0,
  DEV_KBD       = 1,
  DEV_MOUSE     = 2,
  DEV_ABS_MOUSE = 3,
  DEV_GAMEPAD   = 4,
  DEV_KBD_NKRO  = 5,
  DEV_MISC      = 6, // Consumer, System, ...
  DEV_RAW_HID   = 7
};


enum eKbdVariant {
  KBD_VAR_BOOT      = 0,
  KBD_VAR_IMPVD     = 1,
  KBD_VAR_UNUSED0   = 2, // for future use
  KBD_VAR_UNUSED1   = 3  // for future use
};
enum eMouseVariant {
  MOUSE_VAR_BOOT    = 0,
  MOUSE_VAR_IMPVD   = 1,
  MOUSE_VAR_UNUSED0 = 2, // for future use
  MOUSE_VAR_UNUSED1 = 3  // for future use
};
// ...
enum eMiscVariant {
  DEV_MISC_CONSUMER = 0,
  DEV_MISC_SYSTEM   = 1,
  DEV_MISC_UNUSED0  = 2, // for future use
  DEV_MISC_UNUSED1  = 3  // for future use
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

