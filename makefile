TARGET=program
TEST_TARGET=tests

CC=g++
GTEST_DIR=~/googletest/googletest/
GMOCKDIR=~/googletest/googlemock/
GMOCK_LIBS=/usr/lib/libgmock.a /usr/lib/libgmock_main.a
GTEST_LIBS=/usr/lib/libgtest.a /usr/lib/libgtest_main.a

SRCDIR=Source
INCDIR=Include
OBJDIR=obj
BINDIR=bin
TESTDIR=Test
MOCKDIR=$(TESTDIR)/Mocks
TESTOBJDIR=$(TESTDIR)/$(OBJDIR)

LINKER=$(CC) -o
CFLAGS=-I. -I$(INCDIR) -Wall -lm -std=c++14
LFLAGS=-I. -I$(INCDIR) -Wall -std=c++14
LFLAGS_TEST=$(LFLAGS) -lgtest -lgmock -pthread -lm

MAIN=main
TEST_MAIN=main_test
SOURCES := $(wildcard $(SRCDIR)/*cpp)
INCLUDES := $(wildcard $(INCDIR)/*hpp)
OBJECTS := $(SOURCES:$(SRCDIR)/%.cpp=$(OBJDIR)/%.o)
MOCKS := $(wildcard $(MOCKDIR)/*hpp)
TESTINC := $(wildcard $(TESTDIR)/*hpp)
TEST_OBJECTS := $(filter-out $(OBJDIR)/$(MAIN).o, $(OBJECTS))

help:
	@echo "*****************************************************************************"
	@echo "|| Podaj target:                                                           ||"
	@echo "||     "$(TARGET)" - budowanie programu                                        ||"
	@echo "||     "$(TEST_TARGET)" - budowanie testow                                            ||"
	@echo "||     clean - usuniecie plikow *.o                                        ||"
	@echo "||     remove - clear + usuniecie plikow wykonywalnych                     ||"
	@echo "||     remove_tmp - usuniecie plikow *~ oraz .*.swp                        ||"
	@echo "||     build - stworzenie katalogow dla projektu (inicjalizacja)           ||"
	@echo "||     run - uruchomienie programu                                         ||"
	@echo "||     run_tests - uruchomienie testow                                     ||"
	@echo "||     run_valgrind - uruchomienie valgrinda na testach                    ||"
	@echo "*****************************************************************************"

$(TARGET): $(OBJECTS) $(INCLUDES)
	@$(LINKER) $@ $(LFLAGS) $(OBJECTS)
	@mv $(TARGET) $(BINDIR)
	@echo "Linking complete!"

$(OBJECTS): $(OBJDIR)/%.o : $(SRCDIR)/%.cpp $(INCLUDES)
	@$(CC) $(CFLAGS) -c $< -o $@
	@echo "Compiled "$<" successfully!"
	@ctags -R .

$(TEST_TARGET): $(TESTDIR)/$(TEST_MAIN).cpp $(MOCKS) $(TESTINC) $(TEST_OBJECTS)
	@$(LINKER) $(TEST_TARGET) $(TESTDIR)/$(TEST_MAIN).cpp $(TEST_OBJECTS) $(LFLAGS_TEST)
	@mv $(TEST_TARGET) $(BINDIR)
	@echo "Linking complete!"
	@echo "Compiled "$<" successfully!"
	@ctags -R .

.PHONEY: clean
.PHONEY: remove
.PHONEY: build
.PHONEY: remove_tmp
.PHONEY: run
.PHONEY: run_tests
.PHONEY: run_valgrind

clean:
	@rm -f $(OBJECTS)
	@rm -f $(TEST_OBJECTS)
	@echo "Cleanup complete!"

remove: clean
	@rm -f $(BINDIR)/$(TARGET)
	@rm -f $(BINDIR)/$(TEST_TARGET)
	@echo "Executable removed!"

remove_tmp:
	@find . -name '*~' -exec rm -rf {} \;
	@find . -name '.*.swp' -exec rm -rf {} \;
	@echo "Tmp files removed!"

build:
	@mkdir -p $(SRCDIR)
	@mkdir -p $(INCDIR)
	@mkdir -p $(BINDIR)
	@mkdir -p $(OBJDIR)
	@mkdir -p $(TESTDIR)
	@mkdir -p $(MOCKDIR)
	@mkdir -p $(TESTOBJDIR)
	@touch $(SRCDIR)/$(MAIN).cpp
	@[ -s $(SRCDIR)/$(MAIN).cpp ] || \
	    echo "int main()\n\
	{\n\
	}" >> $(SRCDIR)/$(MAIN).cpp
	@touch $(TESTDIR)/$(TEST_MAIN).cpp
	@[ -s $(TESTDIR)/$(TEST_MAIN).cpp ] || \
	    echo "#include <gtest/gtest.h>\n\
	\n\
	int main(int argc, char **argv)\n\
	{\n\
	    ::testing::InitGoogleTest(&argc, argv);\n\
	    return RUN_ALL_TESTS();\n\
	}" >> $(TESTDIR)/$(TEST_MAIN).cpp
	@echo "Project dir tree built!"

run:
	@./$(BINDIR)/$(TARGET)

run_tests:
	@./$(BINDIR)/$(TEST_TARGET)

run_valgrind:
	@valgrind --leak-check=yes ./$(BINDIR)/$(TEST_TARGET)
