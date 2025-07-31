////
////  CounterFeature.swift
////  StudyApp
////
////  Created by Rajesh Mani on 26/06/25.
////
//
//import ComposableArchitecture
//
//
//@Reducer
//struct CounterFeature {
//    @ObservableState
//    struct State: Equatable {
//        var count = 0
//        var numberFact: String?
//    }
//
//    enum Action {
//        case decrementButtonTapped
//        case incrementButtonTapped
//        case numberFactButtonTapped
//        case numberFactResponse(String)
//    }
//
//    @Dependency(\.numberFactClient) var numberFactClient
//
//    var body: some Reducer<State, Action> {
//        Reduce { state, action in
//            switch action {
//            case .decrementButtonTapped:
//                state.count -= 1
//                return .none
//            case .incrementButtonTapped:
//                state.count += 1
//                return .none
//            case .numberFactButtonTapped:
//                return .run { [count = state.count] send in
//                    let fact = try await numberFactClient.fetch(count)
//                    await send(.numberFactResponse(fact))
//                }
//            case let .numberFactResponse(fact):
//                state.numberFact = fact
//                return .none
//            }
//        }
//    }
//}
//
//// (Define or mock numberFactClient as a dependency elsewhere)
