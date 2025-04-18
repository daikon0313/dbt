from dbt.cli.main import dbtRunner

def main():
    dbt = dbtRunner()
    result = dbt.invoke(["--version"])
    print(result.stdout)

if __name__ == "__main__":
    main()