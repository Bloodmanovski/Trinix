#
# Trinix Module Templater Makefile
#

-include $(dir $(lastword $(MAKEFILE_LIST)))../Makefile.cfg


DFLAGS += -I$(TRXDIR)/KernelLand/Kernel -I$(TRXDIR)/KernelLand/Kernel/Architectures/$(ARCHDIR) -I$(TRXDIR)/KernelLand

ifneq ($(CATEGORY),)
	FULLNAME := $(CATEGORY)_$(NAME)
else
	FULLNAME := $(NAME)
endif

ifneq ($(BUILDTYPE),static)
	SUFFIX	:= dyn-$(ARCH)
	KEXT	:= ../$(FULLNAME).kext
	BIN		:= $(KEXT).$(ARCH)
	DFLAGS	+= $(DYNMOD_DFLAGS)
else
	SUFFIX := st-$(ARCH)
	BIN := ../$(NAME).xo.$(ARCH)
	DFLAGS += $(KERNEL_DFLAGS)
endif

OBJ 	 := $(addprefix obj_$(SUFFIX)/,$(OBJ))
DEPFILES := $(OBJ:%=%.dep)

.PHONY: all clean install


all: $(BIN)
	@true

clean:
	@$(RM) $(BIN) $(BIN).dsm obj_st-* obj_dyn-* ../$(FULLNAME).* ../$(NAME).*
	@$(RM) $(DISTROOT)/System/Modules/$(FULLNAME).kext.gz

install: $(BIN)
ifneq ($(BUILDTYPE),static)
	@echo --- Module $(NAME) was installed to System/Modules/$(FULLNAME).kext.gz
	@$(MKDIR) $(DISTROOT)/System/Modules
	@cp $(BIN) $(KEXT)
	@gzip -c $(KEXT) > $(KEXT).gz
	@$(RM) $(KEXT)
	@cp $(KEXT).gz $(DISTROOT)/System/Modules/$(FULLNAME).kext.gz
else
	@true
endif

ifneq ($(BUILDTYPE),static)
$(BIN): $(OBJ)
	@echo --- LD -o $@
	@$(LD) --allow-shlib-undefined -shared -o $@ -defsym=DriverInfo=_DriverInfo_$(FULLNAME) $(LDFLAGS) $<
	@$(OBJDUMP) -d -S $(BIN) > $(BIN).dsm
else
$(BIN): %.xo.$(ARCH): $(OBJ)
	@echo --- LD -o $@
	@$(LD) --script=$(TRXDIR)/KernelLand/Modules/link.ld -r -o $@ $(OBJ)
endif
	
obj_$(SUFFIX)/%.d.o: %.d
	@echo --- DD -o $@
	@$(MKDIR) $(dir $@)
	@$(DD) $(DFLAGS) -of=$@ -c -deps=$@.o.dep $<

	
-include $(DEPFILES)