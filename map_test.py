import marimo

__generated_with = "0.6.5"
app = marimo.App()


@app.cell
def __():
    import marimo as mo
    return mo,


@app.cell
def __():
    import folium

    def click_for_coords(e):
        print(f"Clicked at latitude: {e.latlng[0]} and longitude: {e.latlng[1]}")

    # Create a map object centered at a specific location
    map = folium.Map(location=[51.5236, 13.2750], zoom_start=13)

    # Add a click event to the map
    map.add_child(folium.ClickForLatLng(alert=False))

    # Display the map
    map
    return click_for_coords, folium, map


@app.cell
def __():
    51.543608,14.724426
    return


if __name__ == "__main__":
    app.run()
