import Paymongo from '../payment_methods/paymongo'

export default class PaymentAdapter {
  static paymongo = () => Paymongo.initialize()

  static adapterResponseInterface() {
    return { result: '', error: '' }
  }

  static parsePaymongoResponse(response) {
    const reponseInterface = this.adapterResponseInterface()

    if (response.data && response.data.attributes.status == 'succeeded') return { ...reponseInterface, result: true, error: null }
    if (response.errors) return { ...reponseInterface, result: false, error: response.errors[0].detail }
  }
}
