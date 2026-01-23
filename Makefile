# Makefile for Pigeon code generation

.PHONY: pigeon clean help

# Default target
all: pigeon

# Generate Pigeon code for all platforms
pigeon:
	@echo "Generating Pigeon code..."
	dart run pigeon \
		--input pigeons/app_install_api.dart \
		--dart_out lib/generated/app_install_api.dart \
		--swift_out ios/Classes/GeneratedAppInstallApi.swift \
		--kotlin_out android/src/main/kotlin/com/example/install_app_in_app_store/GeneratedAppInstallApi.kt \
		--kotlin_package com.example.install_app_in_app_store
	@echo "✅ Pigeon code generation completed!"
