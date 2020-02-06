usernames = [
  "batman",
  "superman",
  "spider-man",
  "wolverine",
  "iron man",
  "captain america"
];

const users = usernames.map(i => `{"username": "${i}"}`);

console.log(`{
  "query": "mutation AddUsers($users: [UserInput]) {
    addUsers(usernames: $users) {username}
  }",
  "variables": {
    "users": [${users.join(",")}]
  }
}`);
