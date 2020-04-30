import Foundation

class VendingMachineProduct {
    var name: String
    var amount: Int
    var price: Double
    
    init(name: String, amount: Int, price: Double) {
        self.name = name
        self.amount = amount
        self.price = price
    }
}

//TODO: Definir os erros
enum VendingMachineError: Error {
    case productNotFound
    case productUnavailable
    case productStuck
    case insuficientMoney
    case notMoney
}

extension VendingMachineError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .productNotFound:
            return "Nao tem isso"
        case .productUnavailable:
            return "Acabou"
        case .productStuck:
            return "O seu produto ficou preso"
        case .insuficientMoney:
            return "Tá faltando dinheiro"
        case .notMoney:
            return "Houve um erro no calculo do seu erro"
        }
    }
}

class VendingMachine {
    private var estoque: [VendingMachineProduct]
    private var money: Double
    
    init(products: [VendingMachineProduct]) {
        self.estoque = products
        self.money = 0.0
    }
    
    func getProduct(named name: String, with money: Double) throws {
        //TODO: receber o dinheiro e salvar em uma variável
        self.money += money
        
        //TODO: achar o produto que o cliente quer
        let productOptional = estoque.first { (product) -> Bool in
            return product.name == name
        }
        guard let product = productOptional else { throw VendingMachineError.productNotFound }
        
        //TODO: ver se ainda tem esse produto
        guard product.amount > 0 else { throw VendingMachineError.productUnavailable}
        
        //TODO: ver se o dinheiro é o suficiente pro produto
        guard product.price <= self.money else { throw VendingMachineError.insuficientMoney }
        
        //TODO: entregar o produto
        self.money -= product.price
        if Int.random(in: 0...100) < 10 {
            throw VendingMachineError.productStuck
        }
        
    }
    
    func getTroco(named name: String, with money: Double) throws -> Double {
        //TODO: devolver o dinheiro que não foi gasto
        let money = self.money
        
        // Pegando o produto
        let productOptional = estoque.first { (product) -> Bool in
            return product.name == name
        }
        guard let product = productOptional else { throw VendingMachineError.productNotFound }
        
        if money > product.price {
            self.money = money - product.price
        } else if money == product.price {
            self.money = 0
        } else {
            VendingMachineError.notMoney
        }
        
        return money
    }
}

let vendingMachine = VendingMachine(products: [
    VendingMachineProduct(name: "Carregador de iPhone", amount: 5, price: 150.00),
    VendingMachineProduct(name: "Funnion", amount: 2, price: 7.00),
    VendingMachineProduct(name: "Umbrella", amount: 5, price: 125.00),
    VendingMachineProduct(name: "Trator", amount: 1, price: 75000.00)
])

do {
    try vendingMachine.getProduct(named: "Umbrella", with: 130.00)
    try vendingMachine.getTroco(named: "Funnion", with: 130.00)
    print("Deu bom.")
} catch VendingMachineError.productStuck {
    print("Pedimos desculpa, mas houve um problema, o seu produto ficou preso.")
} catch {
    print(error.localizedDescription)
}
