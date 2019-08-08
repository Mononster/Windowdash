//
//  PaymentMethodsViewModel.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-10-20.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit
import Stripe

final class PaymentMethodsViewModel: PresentableViewModel {

    private let userService: UserAPIService
    private let paymentService: PaymentAPIService
    private let dataStore: DataStoreType
    var sectionData: [ListDiffable] = []

    private var paymentMethods: [PaymentMethodViewModel] = []

    init(userService: UserAPIService,
         paymentService: PaymentAPIService,
         dataStore: DataStoreType) {
        self.userService = userService
        self.paymentService = paymentService
        self.dataStore = dataStore
    }

    func generateSectionData() {
        let header = "Apple Pay users can choose to user Apple Pay at checkout"
        var models: [PaymentMethodPresentingModel] = []
        for paymentMethod in paymentMethods {
            models.append(PaymentMethodPresentingModel(
                id: paymentMethod.model.id,
                title: paymentMethod.displayTitle,
                subTitle: paymentMethod.displaySubTitle,
                isSelected: paymentMethod.isSelected)
            )
        }
        self.sectionData.append(PaymentMethodsPresentingModel(models: models, headerTitle: header))
    }

    func registerStripeCredential(completion: @escaping () -> ()) {
        userService.fetchStripeCredential { (token, error) in
            if let error = error as? APIServiceError {
                log.error(error)
                return
            }
            guard let token = token else {
                log.error("No token? WTF?")
                return
            }
            STPPaymentConfiguration.shared().publishableKey = token
            completion()
        }
    }

    func fetchPaymentMethods(completion: @escaping (String?) -> ()) {
        paymentService.fetchPaymentMethods { (payments, error) in
            if let error = error as? APIServiceError {
                log.error(error)
                completion(error.errorMessage)
                return
            }
            self.paymentMethods = payments.map { payment in
                PaymentMethodViewModel(model: payment)
            }
            self.generateSectionData()
            completion(nil)
        }
    }

    func updateUserDefaultCard(id: Int64, completion: @escaping () -> ()) {
        paymentService.updateDefaultCard(id: id) { (user, error) in
            if let error = error as? APIServiceError {
                log.error(error)
                completion()
                return
            }
            guard let user = user, let currUser = ApplicationEnvironment.current.currentUser else {
                completion()
                return
            }
            if user != currUser {
                ApplicationEnvironment.updateCurrentUser(updatedUser: user)
                try? user.savePersistently(to: self.dataStore)
            }
            completion()
        }
    }
}
