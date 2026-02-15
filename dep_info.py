import os
import subprocess

# Path that contains multiple git repos (each repo = a folder with .git)
BASE_PATH = os.path.dirname(os.path.abspath(__file__))


def run(cmd, cwd):
    """Run command and return output or None."""
    try:
        return subprocess.check_output(cmd, cwd=cwd, stderr=subprocess.DEVNULL).decode().strip()
    except Exception:
        return None


def is_git_repo(path):
    return os.path.isdir(os.path.join(path, ".git"))


def get_repo_info(repo_path):
    url = run(["git", "config", "--get", "remote.origin.url"], repo_path)
    branch = run(["git", "rev-parse", "--abbrev-ref", "HEAD"], repo_path)
    short_hash = run(["git", "rev-parse", "--short", "HEAD"], repo_path)
    return url, branch, short_hash


def main():
    for name in os.listdir(BASE_PATH):
        repo_path = os.path.join(BASE_PATH, name)
        if not os.path.isdir(repo_path):
            continue
        if not is_git_repo(repo_path):
            continue

        url, branch, short_hash = get_repo_info(repo_path)

        print(f"{name}")
        print(f"  {url}")
        print(f"  {branch}")
        print(f"  {short_hash}")


if __name__ == "__main__":
    main()
