import jcamp
import csv

def convert_jdx_to_csv(input_file, output_file):
    # Read JCAMP-DX file
    data = jcamp.jcamp_readfile(input_file)

    # Extract spectrum data
    x_values = data["x"]  # Wavenumbers (cm⁻¹)
    y_values = data["y"]  # Absorbance/Transmittance

    # Write to CSV
    with open(output_file, mode='w', newline='') as file:
        writer = csv.writer(file)
        #writer.writerow(["Wavenumber (cm⁻¹)", "Intensity"])  # Header
        for x, y in zip(x_values, y_values):
            writer.writerow([x, y])

    print(f"Conversion complete: {output_file}")

# Example usage
convert_jdx_to_csv("O3.jdx", "O3.csv")
