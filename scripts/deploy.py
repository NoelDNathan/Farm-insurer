from tkinter.ttk import Widget
from scripts.helpful_scripts import get_account
from brownie import Insurance, Land
from web3 import Web3


def main():
    ownerLand = get_account(0)
    ownerInsurance = get_account(1)
    initial_supply = Web3.toWei(100000000000000, "ether")
    initial_price = 1
    limit = 10000
    insurance = Insurance.deploy({"from": ownerInsurance})
    land = Land.deploy(initial_supply, initial_price,
                       limit, insurance, {"from": ownerLand, "value": Web3.toWei(0.001, "ether")})
    buyPortionLand(land)
    setPriceLand(ownerLand, land)
    withdrawLand(ownerLand, land)
    harvest(ownerLand, land)
    stake(insurance, land)
    isClaimable(insurance, land)
    getBalance(insurance, land)

    getLimit(insurance, land)
    withdrawInsurance(insurance, land)


# Land function

def buyPortionLand(land):
    buyer = get_account(2)
    land.buy({"from": buyer, "value": 100000000})


def setPriceLand(owner, land):
    land.setPrice(Web3.toWei(100, "ether"), {"from": owner})


def withdrawLand(owner, land):
    land.withdraw({"from": owner})


def harvest(owner, land):
    land.harvest({"from": owner})


# Insurance function

def stake(insurance, land):
    staker = get_account(4)
    insurance.stake(land.address, {"from": staker,
                    "value": Web3.toWei(0.01, "ether")})


def withdrawInsurance(insurance, land):
    staker = get_account(4)
    insurance.withdraw(land.address, {"from": staker, "value": 10000})


def getBalance(insurance, land):
    staker = get_account(4)
    print(insurance.getBalance(land.address, {"from": staker}))


def isClaimable(insurance, land):
    staker = get_account(4)
    print(insurance.isClaimable(land.address, {"from": staker}))


def getLimit(insurance, land):
    staker = get_account(4)
    print(insurance.getLimit(land.address, {"from": staker}))
