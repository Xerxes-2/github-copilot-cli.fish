function __fish_add_history
    set -l cmd (string replace -- \n \\n (string join ' ' $argv) | string replace \\ \\\\)
    if test -z $cmd
        return
    end
    begin
        echo -- '- cmd:' $cmd
        and date +' when: %s'
    end >>$__fish_user_data_dir/fish_history
    and history merge
end

function ghcs
    set -f funcname "$_"
    set -f target shell
    set -f GH_DEBUG "$GH_DEBUG"
    set -f GH_HOST "$GH_HOST"

    set -f usage "Wrapper around `gh copilot suggest` to suggest a command based on a natural language description of the desired output effort.
Supports executing suggested commands if applicable.

USAGE
    $funcname [flags] <prompt>

FLAGS
    -d, --debug              Enable debugging
    -h, --help               Display help usage
        --hostname           The GitHub host to use for authentication
    -t, --target target      Target for suggestion; must be shell, gh, git
                             default: $target

EXAMPLES

- Guided experience
    \$ $funcname -t git "Undo the most recent local commits"
    \$ $funcname -t git "Clean up local branches"
    \$ $funcname -t git "Setup LFS for images"

- Working with the GitHub CLI in the terminal
    \$ $funcname -t gh "Create pull request"
    \$ $funcname -t gh "List pull requests waiting for my review"
    \$ $funcname -t gh "Summarize work I have done in issues and pull requests for promotion"

- General use cases
    \$ $funcname "Kill processes holding onto deleted files"
    \$ $funcname "Test whether there are SSL/TLS issues with github.com"
    \$ $funcname "Convert SVG to PNG and resize"
    \$ $funcname "Convert MOV to animated PNG""

    argparse 'd/debug' 'h/help' 'hostname=' 't/target=' -- $argv

    if set -q _flag_debug
        set -f GH_DEBUG api
    end

    if set -q _flag_help
        echo "$usage"
        return 0
    end

    if set -q _flag_hostname
        set -f GH_HOST "$_flag_hostname"
    end

    if set -q _flag_target
        set -f target "$_flag_target"
    end

    set -f tmp_file (mktemp -t gh-copilotXXXXXX)
    trap 'rm -f "$tmp_file"' EXIT

    if GH_DEBUG="$GH_DEBUG" GH_HOST="$GH_HOST" gh copilot suggest -t "$target" "$argv" --shell-out "$tmp_file"
        if test -s "$tmp_file"
            set -f fixed_cmd (cat "$tmp_file")
            __fish_add_history "$fixed_cmd"
            echo
            eval "$fixed_cmd"
        end
    else
        return 1
    end
end

function ghce
    set -f funcname "$_"
    set -f GH_DEBUG "$GH_DEBUG"
    set -f GH_HOST "$GH_HOST"

    set -f usage "Wrapper around `gh copilot execute` to execute a command based on a natural language description of the desired output effort.

USAGE
    $funcname [flags] <prompt>

FLAGS
    -d, --debug              Enable debugging
    -h, --help               Display help usage
        --hostname           The GitHub host to use for authentication

EXAMPLES

# View disk usage, sorted by size
\$ $funcname 'du -sh | sort -h'

# View git repository history as text graphical representation
\$ $funcname 'git log --oneline --graph --decorate --all'

# Remove binary objects larger than 50 megabytes from git history
\$ $funcname 'bfg --strip-blobs-bigger-than 50M'"

    argparse 'd/debug' 'h/help' 'hostname=' -- $argv

    if set -q _flag_debug
        set -f GH_DEBUG api
    end

    if set -q _flag_help
        echo "$usage"
        return 0
    end

    if set -q _flag_hostname
        set -f GH_HOST "$_flag_hostname"
    end

    GH_DEBUG="$GH_DEBUG" GH_HOST="$GH_HOST" gh copilot explain "$argv"
end
