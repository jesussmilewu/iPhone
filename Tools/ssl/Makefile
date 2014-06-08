INSTALL_DIR = /etc/apache/ssl
BUILD_DIR = build
OPENSSL = openssl
DAYS = 750

CONFIG_FILE = ssl.config
CA_KEY = $(BUILD_DIR)/ca.key
CA_CRT = $(BUILD_DIR)/ca.crt
CLIENT_KEY = $(BUILD_DIR)/client.key
CLIENT_CSR = $(BUILD_DIR)/client.csr
CLIENT_CRT = $(BUILD_DIR)/client.crt
SERVER_KEY = $(BUILD_DIR)/server.key
SERVER_CSR = $(BUILD_DIR)/server.csr
SERVER_CRT = $(BUILD_DIR)/server.crt

all:
	@echo "make ssl"
	@echo "make clean"

ssl: $(BUILD_DIR) $(CA_KEY) $(SERVER_CRT) $(CLIENT_CRT) $(SERVER_KEY) $(CLIENT_KEY)

.PHONY: prepare clean

$(BUILD_DIR): prepare
	mkdir $(BUILD_DIR)

$(CA_KEY): $(BUILD_DIR)
	$(OPENSSL) genrsa -des3 -out $@ 4096

$(CA_CRT): $(CA_KEY)
	$(OPENSSL) req -new -x509 -days $(DAYS) -config $(CONFIG_FILE) -key $< -out $@

%.key: $(BUILD_DIR)
	$(OPENSSL) genrsa -des3 -passout "pass:1234test" -out $@ 1024
	mv $@ $@.orig
	$(OPENSSL) rsa -passin "pass:1234test" -in $@.orig -out $@
	rm $@.orig

%.csr: %.key
	$(OPENSSL) req -new -config $(CONFIG_FILE) -key $< -out $@

$(SERVER_CRT): $(SERVER_CSR) $(CA_CRT)
	$(OPENSSL) x509 -req -days $(DAYS) -in $< -signkey $(SERVER_KEY) -CA $(CA_CRT) -CAkey $(CA_KEY) -set_serial 01 -out $@

$(CLIENT_CRT): $(CLIENT_CSR) $(CA_CRT)
	$(OPENSSL) x509 -req -days $(DAYS) -in $< -CA $(CA_CRT) -CAkey $(CA_KEY) -set_serial 01 -out $@

clean:
	rm -rf $(BUILD_DIR)
