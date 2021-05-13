export default function parseAmount(amount) {
  return new Intl.NumberFormat('fil-PH', {
    style: 'currency',
    currency: 'PHP'
  }).format(amount)
}