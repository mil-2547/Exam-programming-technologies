CXX      := g++
CXXFLAGS ?= -std=c++20 -O3 -Wall -Wextra -pipe -march=x86-64 -Iinclude/vendors/asio/include -Iinclude/vendors/googletest/include -Iinclude
LDFLAGS  ?= -static -pthread
GTFLAGS  ?= -Linclude/vendors/googletest/lib -lgtest -lgtest_main

TARGET := crow_app
PCH    := /pch/pch.h.gch
PCH_SRC:= include/pch.h
SRC    := $(wildcard src/*.cpp)
OBJDIR := build/obj
BINDIR := build/bin
OBJ    := $(patsubst src/%.cpp,$(OBJDIR)/%.o,$(SRC))

# Separate app main from shared objects (assuming src/main.cpp exists; adjust if named differently)
APP_MAIN_OBJ := $(OBJDIR)/main.o
SHARED_OBJ := $(filter-out $(APP_MAIN_OBJ), $(OBJ))

pch: $(PCH)
$(PCH): include/pch.h
	@echo "[PCH] Building precompiled header..."
	$(CXX) $(CXXFLAGS) -x c++-header $(PCH_SRC) -o $(PCH)

$(OBJDIR)/%.o: src/%.cpp $(PCH)
	@mkdir -p $(OBJDIR)
	@echo "[CC] $<"
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BINDIR)/$(TARGET): $(APP_MAIN_OBJ) $(SHARED_OBJ)
	@mkdir -p $(BINDIR)
	@echo "[LD] Linking $@"
	$(CXX) $(APP_MAIN_OBJ) $(SHARED_OBJ) -o $@ $(LDFLAGS)

TEST_SRC := tests/test.cpp
TEST_OBJ := $(OBJDIR)/test.o

build-tests: $(BINDIR)/Test

$(BINDIR)/Test: $(TEST_OBJ) $(SHARED_OBJ)
	@mkdir -p $(BINDIR)
	$(CXX) $(TEST_OBJ) $(SHARED_OBJ) -o $@ $(LDFLAGS) $(GTFLAGS)
	
$(OBJDIR)/test.o: tests/test.cpp $(PCH)
	@mkdir -p $(OBJDIR)
	@echo "[CC][TEST] $<"
	$(CXX) $(CXXFLAGS) -c $< -o $@

all: $(BINDIR)/$(TARGET)

.PHONY: clean
clean:
	rm -rf build/*