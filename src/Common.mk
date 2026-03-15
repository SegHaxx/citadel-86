ifeq ($(OS),Windows_NT)
RM=del /Q /F
CP=copy /Y
else
RM=rm -rf
CP=cp -f
endif

src=$(wildcard *.c)
obj=$(src:.c=.obj)

.PHONY: clean depclean

clean:
	$(RM) $(TARGETS) $(obj)
	$(RM) *.lib

dep: .depend

.depend: $(src)
	gcc -MM $^ > $@
	sed -i 's/.o:/.obj:/' $@

depclean:
	$(RM) .depend
