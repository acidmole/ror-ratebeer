import  { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["amount", "abv", "price", "customAmount"];
    static values = { vat: Number};


    calculate(event) {
        // Prevent the default form submission from reloading the page.
        event.preventDefault();
        let amount = 0.0;
        console.log(this.amountTarget.value)
        if (this.amountTarget.value === "-1") {
            console.log(this.customAmountTarget.value)
            amount = parseFloat(this.customAmountTarget.value);
        }
        else {
            amount = parseFloat(this.amountTarget.value);
        }
        const abv = parseFloat(this.abvTarget.value);
        const price = parseFloat(this.priceTarget.value);

        let alcoholTax = 0;
        switch (true) {
            case (abv < 0.5):
                alcoholTax = 0;
            case (abv <= 3.5):
                alcoholTax = 0.2835;
            case (abv > 3.5):
                alcoholTax = 0.3805;
        }
        const beerTax = (amount * abv * alcoholTax);
        const vatAmount = (price - price / (1.0 + this.vatValue));
        const taxPercentage = ((beerTax + vatAmount) / price * 100);

        // search for the element where the result is shown
        const result = document.getElementById("result")
        result.innerHTML = `
        <p>Beer has ${beerTax.toFixed(2)} € of alcohol tax and ${vatAmount.toFixed(2)} € of value added tax.</p>
        <p> ${taxPercentage.toFixed(1)} % of the price is taxes.</p>`
    }
    reset(event) {
        event.preventDefault();
        this.amountTarget.value = "0.000";
        this.abvTarget.value = "0.00";
        this.priceTarget.value = "0.00";
        const result = document.getElementById("result")
        result.innerHTML = ""
    }
    change(event) {
        // checks if "Custom" was selected and then displays the custom amount input
        if (event.target.value === "-1") {
            const customAmount = document.getElementById("custom-amount");
            customAmount.style.display = "block";
        }
        else {
            const customAmount = document.getElementById("custom-amount");
            customAmount.style.display = "none";
        }

    }
}