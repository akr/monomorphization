.PHONY: all install plugin check checker clean development-without-install revert-development-without-install

-include Makefile.coq.conf

all : Makefile.coq
	$(MAKE) -f Makefile.coq $@

install : Makefile.coq
	test ! theories -ef $(COQMF_COQLIB)/user-contrib/codegen || ( echo "$(COQMF_COQLIB)/user-contrib/codegen is linked to theories.  No need to install."; false )
	$(MAKE) -f Makefile.coq $@

ifdef COQMF_COQLIB
development-without-install : revert-development-without-install
	ln -s ../src/codegen_plugin.cmi theories
	ln -s ../src/codegen_plugin.cmxs theories
	ln -s ../src/codegen_plugin.cmxa theories
	ln -s ../src/codegen_plugin.cmx theories
	ln -s `pwd`/theories $(COQMF_COQLIB)/user-contrib/codegen

revert-development-without-install :
	rm -f theories/codegen_plugin.cmi
	rm -f theories/codegen_plugin.cmxs
	rm -f theories/codegen_plugin.cmxa
	rm -f theories/codegen_plugin.cmx
	rm -f $(COQMF_COQLIB)/user-contrib/codegen
else
development-without-install :
	@echo 'COQMF_COQLIB not defined.  run "make" first.'
revert-development-without-install :
	@echo 'COQMF_COQLIB not defined.  run "make" first.'
endif

plugin : Makefile.coq
	$(MAKE) -f Makefile.coq src/codegen_plugin.cmxs

.merlin : Makefile.coq
	$(MAKE) -f Makefile.coq .merlin

# Makefile.coq.conf is also generated by coq_makefile.
Makefile.coq : _CoqProject
	coq_makefile -f _CoqProject -o Makefile.coq

check checker:
	cd test; $(MAKE) $@

clean :
	rm -f \
	  .Makefile.coq.d \
	  src/g_codegen.ml \
	  src/*.o \ \
	  src/*.cmi \
	  src/*.cmo \
	  src/*.cmx \
	  src/*.cma \
	  src/*.cmt \
	  src/*.cmxa \
	  src/*.cmxs \
	  src/*.a \
	  src/*.d \
	  src/*.annot \
	  theories/*.glob \
	  theories/*.vo \
	  theories/*.vok \
	  theories/*.vos \
	  theories/*.d \
	  theories/.*.aux \
	  test/*.cache \
	  test/test_codegen \
	  test/*.cmi \
	  test/*.cmx \
	  test/*.o \
	  test/oUnit-* \
	  sample/pow \
	  sample/rank \
	  sample/*.vo \
	  sample/*.vok \
	  sample/*.vos \
	  sample/*.glob \
	  sample/.*.aux \
	  oUnit-*

distclean : clean
	rm -f \
	  Makefile.coq \
	  Makefile.coq.conf
