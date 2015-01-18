majordomus
===

A tiny PaaS
---

Basic setup:

	bash <(curl -s https://raw.githubusercontent.com/majordomus/majordomus/master/bootstrap.sh)


#### Create a user by uploading a public key from your laptop

We just pipe our local SSH key into the `gitreceive upload-key` command via SSH:

    $ cat ~/.ssh/id_rsa.pub | ssh you@dev.getmajordomus.local "sudo gitreceive upload-key <username>"

The `username` argument is just an arbitrary name associated with the key, mostly
for use in your system for auth, etc.

`gitreceive upload-key` will authorize this key for use on the `$GITUSER`
account on the server, and use the SSH "forced commands" syntax in the remote
`.ssh/authorized_keys` file,  causing the internal `gitreceive run` command to
be called when this key is used with the remote git account. This allows us to
intercept the `git` requests and set up a `pre-receive` hook to run on the
repo, which triggers the custom receiver script.

#### Add a remote to a local repository

    $ git remote add demo git@dev.getmajordomus.local:example

The repository `example` will be created on the fly when you push.
