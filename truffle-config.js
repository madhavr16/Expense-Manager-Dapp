module.exports = {
  networks: {
    development: {
      host: "192.168.18.41",
      port: 7546,
      network_id: "*"
    }
  },
  contracts_directory: './contracts',
  compilers: {
    solc: {
      version: "0.8.19",
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  db: {
    enabled: false
  }
}