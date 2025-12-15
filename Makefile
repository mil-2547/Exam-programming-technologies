CXX      := g++
CXXFLAGS ?= -std=c++20 -O3 -Wall -Wextra -pipe -march=x86-64 -Iinclude/vendors/asio/include -Iinclude/vendors/googletest/include -Iinclude
LDFLAGS  ?= -static -pthread
GTFLAGS  ?= -L/googletest/lib -lgtest -lgtest_main

TARGET := crow_app
PCH    := /pch/pch.h.gch
PCH_SRC:= include/pch.h
SRC    := $(wildcard src/*.cpp)
OBJDIR := build/obj
BINDIR := build/bin
OBJ    := $(patsubst src/%.cpp,$(OBJDIR)/%.o,$(SRC))

pch: $(PCH)
$(PCH): include/pch.h
	@echo "[PCH] Building precompiled header..."
	$(CXX) $(CXXFLAGS) -x c++-header $(PCH_SRC) -o $(PCH)

$(OBJDIR)/%.o: src/%.cpp $(PCH)
	@mkdir -p $(OBJDIR)
	@echo "[CC] $<"
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BINDIR)/$(TARGET): $(OBJ)
	@mkdir -p $(BINDIR)
	@echo "[LD] Linking $@"
	$(CXX) $(OBJ) -o $@ $(LDFLAGS)

TEST_SRC := src/test.cpp
TEST_OBJ := $(OBJDIR)/test.o
$(BINDIR)/Test: $(TEST_OBJ) $(OBJ)
	@mkdir -p $(BINDIR)
	$(CXX) $(TEST_OBJ) $(OBJ) -o $@ $(LDFLAGS) $(GTFLAGS)
build-tests: $(BINDIR)/Test

all: $(BINDIR)/$(TARGET)

.PHONY: clean
clean:
	rm -rf build/*
