ifneq ("${SHELL}", "/bin/bash")
	export SHELL=/bin/bash
endif

SDIR = src

TARGET_PLATFORM ?= $(shell python -c "import os;p = os.sys.platform;print(p.startswith('linux') and 'Linux' or (p.startswith('darwin') and 'Apple' or 'Android_arm'))")

ifeq ("${TARGET_PLATFORM}", "Linux")
platforms = $(shell find build/platforms -name "*.cmake"|grep -Ev "(Apple|macOS|iOS)"|sort)
else ifeq ("${TARGET_PLATFORM}", "Apple")
platforms = $(shell find build/platforms -name "*.cmake"|grep -Ev "(Linux|LeChange|Junz|AllWinner)"|sort)
else
platforms = $(shell find build/platforms -name "*.cmake"|sort)
endif
select_platform=t=`echo $(1)|awk -v idx=$(2) '{for(i=1;i<=NF;++i){if((i-1)==idx){print $$i}}}'|sed -e 's@build/platforms/@@' -e 's@.cmake@@'`

all: ./.build
	@cd .build && cmake -DCMAKE_BUILD_TYPE=Release ..
	@make -C ./.build --no-print-directory clean all -j

debug: ./.build
	@echo "Supported targets, please enter your choice: (0-`echo ${platforms}|awk '{print NF-1}'`)"
	@for t in ${platforms}; do 																				\
		printf "($$((i++))): ";																				\
		echo $${t/build\/platforms\//} | sed -e 's#.cmake##' ; 												\
	done
	@read input;$(call select_platform,${platforms},$${input}); 											\
		cd .build && cmake -DTARGET_PLATFORM=$${t} -DCMAKE_BUILD_TYPE=Debug ..
	@read -n1 -p "Press any key to continue ... "
	@make -C ./.build --no-print-directory clean all -j

release: ./.build
	@echo "Supported targets, please enter your choice: (0-`echo ${platforms}|awk '{print NF-1}'`)"
	@for t in ${platforms}; do 																				\
		printf "($$((i++))): ";																				\
		echo $${t/build\/platforms\//} | sed -e 's#.cmake##' ; 												\
	done
	@read input;$(call select_platform,${platforms},$${input}); 											\
		cd .build && cmake -DTARGET_PLATFORM=$${t} -DCMAKE_BUILD_TYPE=Release ..
	@read -n1 -p "Press any key to continue ... "
	@make -C ./.build --no-print-directory clean all -j


clean: ./.build
	@rm -fr ./.build/* include/morvoice/mor_version.h

.PHONY: all clean debug release

SOURCE_DIRS = ${SDIR} test
CTAGS = ctags
CTAGS_FLAGS = --c++-kinds=+p --fields=+iaS --extra=+q --exclude=/.bak/ --langmap=c++:+.cu
update-ctags:
	@which ${CTAGS} >/dev/null && ${CTAGS} ${CTAGS_FLAGS} -f .tags -R ${SOURCE_DIRS} 						\
		|| echo "ERROR: ${CTAGS} not found"

./.build:
	@mkdir -p $@
	@cd .build && cmake -DDEFAULT_TARGET_PLATFORM=${TARGET_PLATFORM} ..

.PHONY: update-ctags

-include build/project.mk

source_exts = -name "*.c" -o -name "*.h" -o -name "*.cpp" -o -name "*.cu"
update-src-header  = for fn in `find $(1) -type f -a \( ${source_exts} \)`; do 								\
		sed -i -E "s@\* FileName[ \t]*: .*@* FileName : $${fn}@g" $${fn}; 									\
	done

_update_version:
	@for fn in `find ${SDIR} -type f -a \( ${source_exts} \)`; do											\
		yr=$$(date +"%Y");																					\
		dn=$$(dirname $${fn}|sed -e "s@/@_@g" -e "s@\(.*\)@\U\1@g");										\
		ff=$$(basename $${fn}|sed -e "s@/@_@g" -e "s@\.@_@g" -e "s@\(.*\)@\U\1@g");							\
		sed -i -e "s@#ifndef __AISPEECH__.*[_H]*_*@#ifndef __AISPEECH__$${dn}__$${ff}__@g"					\
			   -e "s@#define __AISPEECH__.*[_H]*_*@#define __AISPEECH__$${dn}__$${ff}__@g"					\
			   -e "s@COPYRIGHT (C) [0-9]*,@COPYRIGHT (C) $${yr},@g"											\
			   -e "s@#endif //__AISPEECH__.*[_H]*_*@#endif //__AISPEECH__$${dn}__$${ff}__@g" $${fn};		\
	done

	@find ${SDIR} test -type f -a \( ${source_exts} \) -exec sed -E -i 's@\* Project[ \t]*: .*$$@* Project  : ${PROJECT_NAME}.${PROJECT_VERSION}@g' {} +
	@$(call update-src-header,${SOURCE_DIRS})

update-version: build/project.mk
	@make update
	@make _update_version

.PHONY: update-version _update_version


update-doc: doc/mkdocs.yml
	@cd doc && mkdocs build

.PHONY: update-doc


update-api:
	@for fn in `find ${SDIR} -type f -name "api_*.h"`; do  													\
		cat $${fn} | awk 'BEGIN{ex=0;}{																		\
			if($$0~/API_EXPORT END/){ex=0;}																	\
			if(ex == 1){print $$0}																			\
			if($$0~/API_EXPORT START/){ex=1;}}' > api/`basename $${fn}`;							 		\
	done

.PHONY: update-api
