/* ************************************************************************ */
/*                                                                          */
/*   SPDX-License-Identifier LGPL-2.1                                       */
/*   Copyright (C)                                                          */
/*   CEA (Commissariat à l'énergie atomique et aux énergies alternatives)   */
/*                                                                          */
/* ************************************************************************ */

/* -------------------------------------------------------------------------- */
/* --- Why3 LSP Client                                                    --- */
/* -------------------------------------------------------------------------- */

import {
  window,
  workspace,
  Disposable,
  OutputChannel,
} from 'vscode';

import {
  Executable,
  LanguageClient,
  LanguageClientOptions,
  TransportKind,
} from 'vscode-languageclient/node';

/* -------------------------------------------------------------------------- */
/* --- Language Client (server on standard input/output)                  --- */
/* -------------------------------------------------------------------------- */

export default class Client implements Disposable {
  private readonly output: OutputChannel;
  private client: LanguageClient | undefined;

  constructor() {
    this.output = window.createOutputChannel('Why3 LSP');
    this.start = this.start.bind(this);
    this.stop = this.stop.bind(this);
  }

  log(msg: any) { this.output.appendLine(`[VSCode] ${msg.toString()}`); }

  async dispose(): Promise<void> {
    await this.stop();
    this.output.dispose();
  }

  async start(): Promise<void> {
    await this.stop();
    // The client launches the server and talks to it on stdin/stdout
    // (the client library adds the argument '--stdio')
    const serverOptions: Executable = {
      command: 'why3find',
      args: ['lsp'],
      transport: TransportKind.stdio,
    };
    const clientOptions: LanguageClientOptions = {
      outputChannel: this.output,
      documentSelector: [{ scheme: 'file', language: 'why3' }],
      synchronize: {
        fileEvents: [
          workspace.createFileSystemWatcher('**/*.mlw'),
          workspace.createFileSystemWatcher('**/why3find.json'),
        ]
      }
    };
    this.client = new LanguageClient(
      'why3lsp', 'Why3 Language Server',
      serverOptions,
      clientOptions
    );
    this.log('start client');
    await this.client.start();
  }

  async stop(): Promise<void> {
    const client = this.client;
    if (client) {
      this.log('stop client');
      this.client = undefined;
      await client.stop();
    }
  }

  async send(method: string, params?: any) : Promise<any> {
    return this.client?.sendRequest(method,params);
  }

}

/* -------------------------------------------------------------------------- */
