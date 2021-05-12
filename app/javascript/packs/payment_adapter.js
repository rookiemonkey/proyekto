import Paymongo from './payment_methods/paymongo'

export default class PaymentAdapter {
  static paymongo = () => Paymongo.initialize()
}
