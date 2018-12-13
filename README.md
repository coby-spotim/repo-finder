# RepoFinder

Find matching repos connected to an organization quickly!

## Usage

### Notice

In the current state, RepoFinder works only in the command line of Elixir (`iex`).

Creating a `mix` task is in the roadmap.

### Find Repositories

#### Using An Access Token

```
> iex -S mix
> opts = [access_token: "XXXXXXXXXXXXX", organization: "XXXXXXXX"]
> RepoFinder.run(opts)
```

#### Using User and Password

```
> iex -S mix
> opts = [user: "XXXXXXXXXXXXX", password: "XXXXXXXXXXXXX", organization: "XXXXXXXX"]
> RepoFinder.run(opts)
```

#### Using Language Filter

```
> iex -S mix
> opts = [access_token: "XXXXXXXXXXXXX", organization: "XXXXXXXX", lanugage: "XXXX"]
> RepoFinder.run(opts)
```

#### Using Name Pattern Filter

```
> iex -S mix
> opts = [access_token: "XXXXXXXXXXXXX", organization: "XXXXXXXX", pattern: ~r/XXXX/]
> RepoFinder.run(opts)
```