export function numberWithCommas(x) {
  try {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  }
  catch (err) {
    return ""
  }
}
