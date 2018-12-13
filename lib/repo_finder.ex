defmodule RepoFinder do
  @moduledoc """
  ## RepoFinder
  This package lets you find repositories on Github connected to a specific organization.

  You can filter repos by matching name patterns (regex), as well as by matching languages.

  The run function will automatically take the organization that you have specified, and find all teams of that organization,
  and extract tha repositories for each team.

  It will then filter based on your preferences, and return the matching repositories.
  """

  alias Tentacat.{Client, Organizations, Teams}

  defmodule Team do
    defstruct name: nil, id: nil
  end

  defmodule Repo do
    defstruct name: nil, language: nil, ssh_url: nil
  end

  @doc """

  """
  def run(opts) when is_list(opts) do
    {access_token, opts} = Keyword.pop(opts, :access_token)
    {user, opts} = Keyword.pop(opts, :user)
    {password, opts} = Keyword.pop(opts, :password)
    {pattern, opts} = Keyword.pop(opts, :pattern)
    {language, opts} = Keyword.pop(opts, :language)
    organization = Keyword.fetch!(opts, :organization)
    client = create_client(access_token, user, password)
    teams = get_all_teams(client, organization)

    Enum.flat_map(teams, fn team -> list_team_repos(client, team) end)
    |> Enum.filter(fn repo -> matching_language?(repo, language) end)
    |> Enum.filter(fn repo -> matching_name_pattern?(repo, pattern) end)
  end

  defp create_client(token, _, _) when not is_nil(token), do: get_client(token)
  defp create_client(_, user, password) when not is_nil(password), do: get_client(user, password)
  defp create_client(_, _, _), do: get_client()

  defp get_client(access_token) do
    Client.new(%{access_token: access_token})
  end

  defp get_client(user, password) do
    Client.new(%{user: user, password: password})
  end

  defp get_client() do
    Client.new()
  end

  defp get_all_teams(client, organization) do
    {200, teams, _response} = Organizations.Teams.list(client, organization)
    Enum.map(teams, fn team -> %Team{name: team["name"], id: team["id"]} end)
  end

  defp list_team_repos(client, team) do
    repositories =
      if is_tuple(resp = Teams.Repositories.list(client, team.id)) do
        elem(resp, 1)
      else
        resp
      end

    Enum.map(repositories, fn repo ->
      %Repo{name: repo["name"], language: repo["language"], ssh_url: repo["ssh_url"]}
    end)
  end

  defp matching_language?(nil, _), do: false
  defp matching_language?(_, nil), do: true
  defp matching_language?(repo, language), do: repo.language == language

  defp matching_name_pattern?(nil, _), do: false
  defp matching_name_pattern?(_, nil), do: true
  defp matching_name_pattern?(repo, pattern), do: Regex.match?(pattern, repo.name)
end
