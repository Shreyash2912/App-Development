// JavaScript CRUD on Array
let fruits = ["Apple", "Banana", "Mango"];

function displayFruits() {
  console.log("\n Current Fruits:");
  fruits.forEach((fruit, index) => {
    console.log(`  ${index}: ${fruit}`);
  });
}

function addFruit(newFruit) {
  fruits.push(newFruit);
  console.log(`Added "${newFruit}"`);
}

function updateFruit(index, updatedFruit) {
  if (index >= 0 && index < fruits.length) {
    console.log(` Updated "${fruits[index]}" to "${updatedFruit}"`);
    fruits[index] = updatedFruit;
  } else {
    console.log(" Invalid index for update.");
  }
}

function deleteFruit(index) {
  if (index >= 0 && index < fruits.length) {
    console.log(` Deleted "${fruits[index]}"`);
    fruits.splice(index, 1);
  } else {
    console.log(" Invalid index for deletion.");
  }
}

//  Sample CRUD operations
displayFruits();
addFruit("Kiwi");
displayFruits();
updateFruit(1, "Pineapple");
displayFruits();
deleteFruit(0);
displayFruits();
