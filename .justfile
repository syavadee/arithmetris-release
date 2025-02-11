@help:
    just --summary
set dotenv-load := true
tag := `git tag -l |tail -n1`
newtag := `git tag -l |tail -n1 |python3 -c "print('v' + '.'.join(map(str,(lambda lst: lst[:-1] + [(lst[-1]+1)])(list(map(int,input()[1:].split('.')))))))"`
@tag:
    echo {{ tag }}
    git tag --delete {{ tag }} || true
    git push --delete origin {{ tag }} || true
    git tag {{ tag }}
    git push
    git push --tags

@newtag:
    echo {{ newtag }}

@test:
    echo v1.0.7 | python3 -c "print('v' + '.'.join(map(str,(lambda lst: lst[:-1] + [(lst[-1]+1)])(list(map(int,input()[1:].split('.')))))))"

@curl:
    curl -H "X-GitHub-Api-Version: 2022-11-28" -H "Accept: application/octet-stream" \
        -H "Authorization: token $PRIVATE_REPO_TOKEN" \
        -L https://api.github.com/repos/syavadee/arithmetris/releases/assets/227946066 > app-release.apk

@release:    
    gh api -H "Authorization: token $PRIVATE_REPO_TOKEN" /repos/$PRIVATE_REPO/releases/$RELEASE_ID/assets

@release_id:
    gh api /repos/$PRIVATE_REPO/releases/tags/$TAG_NAME | jq -r '.id'    
    gh api /repos/$PRIVATE_REPO/releases/tags/$TAG_NAME | jq -r '.assets[].url'
    gh api /repos/$PRIVATE_REPO/releases/tags/$TAG_NAME | jq -r '.assets[].name'
