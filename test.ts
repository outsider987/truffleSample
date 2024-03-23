function solution(number: string): string {
  function convert(inputStr: String): string {
    let result = "";
    let i = 0;
    while (i < inputStr.length) {
      let digit = inputStr[i]; // get 6
      let sum = parseInt(digit); // to number

      let j = i + 1; // get next elm index

      // next elm loop and need the same number
      while (j < inputStr.length && inputStr[j] === digit) {
        sum += parseInt(digit); // added
        j++; // next elm loop
      }
      // finished last round added
      result += sum;

      i = j;
    }

    // final check

    if (checkPreviousNextSame(result.split(""))) {
      return convert(result);
    }

    return String(result);
  }

  return String(convert(number));
}

solution("66644319333");
console.log(solution("66644319333"));

function checkPreviousNextSame(arr) {
  return arr.slice(0, -1).some((v, i) => v === arr[i + 1]);
}


