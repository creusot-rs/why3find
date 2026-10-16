LSP over stdio (--stdio)

  $ lsp() { printf 'Content-Length: %d\r\n\r\n%s' ${#1} "$1"; }
  $ { lsp '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"capabilities":{}}}'; lsp '{"jsonrpc":"2.0","id":2,"method":"shutdown"}'; } | why3find lsp --stdio 2>/dev/null | tr '\r' ' ' | grep -o '"id":[0-9]*,"result":[^,]*' 
  "id":1,"result":{"capabilities":{"textDocumentSync":{"openClose":true
  "id":2,"result":null}
