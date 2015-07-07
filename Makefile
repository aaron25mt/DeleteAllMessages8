include theos/makefiles/common.mk

TWEAK_NAME = DeleteAllMessages8
DeleteAllMessages8_FILES = Tweak.xm
DeleteAllMessages8_FRAMEWORKS = UIKit CoreGraphics Foundation ChatKit
DeleteAllMessages8_PRIVATE_FRAMEWORKS = ChatKit

export ARCHS = armv7 arm64

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
