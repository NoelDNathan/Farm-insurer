from brownie import (network, config, accounts)
from web3 import Web3

FORKED_LOCAL_ENVIORMENTS = ["mainnet-fork", "mainnet-fork-dev"]
LOCAL_BLOCKCHAIN_ENVIROMENTS = [
    "development", "ganache--local", "local-ganache", "mainnet-fork"]


def get_account(index=None, id=None):
    if index:
        return accounts[index]
    if id:
        return accounts.load(id)
    if (network.show_active() in LOCAL_BLOCKCHAIN_ENVIROMENTS
            or network.show_active() in FORKED_LOCAL_ENVIORMENTS):
        return accounts[0]

    return accounts.add(config["wallets"]["from_key"])
