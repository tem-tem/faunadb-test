usernames = [
  "batman",
  "superman",
  "spider-man",
  "wolverine",
  "iron man",
  "captain america"
];

const buildGraphQLSeed = () => {
  const users = usernames.map(i => `{"username": "${i}"}`);

  return `{
    "query": "mutation AddUsers($users: [UserInput]) {
      addUsers(usernames: $users) {username}
    }",
    "variables": {
      "users": [${users.join(",")}]
    }
  }`;
};

// this makes it possible to access the result from bash
console.log(buildGraphQLSeed());
