public class BlueCellGrid extends HDrawable {

	private int _cellSize = 3;
	private int _cellGap = 1;
	private int _gridGap = 2;
	private int _numberOfCellsPerGridSide = 5;

	private color _startColor = #54C9F4;
	private color _endColor = #A6E2FC;

	private PCHLightweightCanvas _backgroundGradientLWC;
	private PCHLightweightCanvas _cellGridLWC;
	private PCHLightweightCanvas _overlayLWC;

	private boolean _needsRender = true;

	private PGraphics _cellUnitRowReusableBuffer;
	private boolean _startedRenderingCellUnitRow;
	private PGraphics _cellUnitReusableBuffer;
	private boolean _startedRenderingCellUnit;
	private PGraphics _cellGridRowReusableBuffer;
	private boolean _startedRenderingCellGridRow;

	// Constructors

	public void init() {
		if (_backgroundGradientLWC != null)
			_backgroundGradientLWC.popOut();
		else
			_backgroundGradientLWC = null;

		if (_cellGridLWC != null)
			_cellGridLWC.popOut();
		else
			_cellGridLWC = null;

		if (_overlayLWC != null)
			_overlayLWC.popOut();
		else
			_overlayLWC = null;

		_needsRender = true;
		_cellUnitRowReusableBuffer = null;
		_startedRenderingCellUnitRow = false;
		_cellUnitReusableBuffer = null;
		_startedRenderingCellUnit = false;
		_cellGridRowReusableBuffer = null;
		_startedRenderingCellGridRow = false;
	}

	public BlueCellGrid() {
		init();

		render();
	}

	public BlueCellGrid(int w, int h) {
		size(w, h);

		render();
	}

	// Synthesizers

	public boolean needsRender() {
		return _needsRender;
	}

	// Class methods
	//
	//

	int widthOfGridColumn() {
		return (_cellSize+_cellGap)*_numberOfCellsPerGridSide - _cellGap;
	}

	int widthOfGridColumnAndGap() {
		return (_cellSize+_cellGap)*_numberOfCellsPerGridSide - _cellGap + _gridGap;
	}

	int heightOfGridRow() {
		return (_cellSize+_cellGap)*_numberOfCellsPerGridSide - _cellGap;
	}

	int heightOfGridRowAndGap() {
		return (_cellSize+_cellGap)*_numberOfCellsPerGridSide - _cellGap + _gridGap;
	}

	int numberOfGridColumnsForWidth(float aWidth) {
		return (int)Math.floor((aWidth+_gridGap)/(widthOfGridColumn()+_gridGap));
	}

	int numberOfGridColumns() {
		return numberOfGridColumnsForWidth(_width);
	}

	int numberOfGridRowsForHeight(float aHeight) {
		return (int)Math.floor((aHeight+_gridGap)/(heightOfGridRow()+_gridGap));
	}

	int numberOfGridRows() {
		return numberOfGridRowsForHeight(_height);
	}

	int totalWidthOfGridSpan() {
		return (widthOfGridColumn()+_gridGap)*numberOfGridColumns() - _gridGap;
	}

	int totalHeightOfGridSpan() {
		return (heightOfGridRow()+_gridGap)*numberOfGridRows() - _gridGap;
	}

	PVector gridOffset() {
		int gridOffsetX = (int)(_width-totalWidthOfGridSpan())/2;
		int gridOffsetY = (int)(_height-totalHeightOfGridSpan())/2;

		return new PVector(gridOffsetX, gridOffsetY);
	}

	PVector pointCoordinatesForGridAndCellCoordinates(int gridColumn, int gridRow, int cellColumn, int cellRow) {
		float offsetX = gridColumn * (widthOfGridColumn() + _gridGap) + cellColumn * (_cellSize+_cellGap);
		float offsetY = gridRow * (heightOfGridRow() + _gridGap) + cellRow * (_cellSize+_cellGap);

		return new PVector(offsetX, offsetY);
	}

	// Rendering subroutines

	void renderBackgroundGradient() {
		// instantiate cell unit, render to offscreen graphics
		// when finished rendering, lightweight add to lwc
		// when

		if (_backgroundGradientLWC == null) {
			_backgroundGradientLWC = new PCHLightweightCanvas(_width, _height);
			add(_backgroundGradientLWC);

			PCHLinearGradient backgroundGrad = new PCHLinearGradient(_startColor, _endColor);
			backgroundGrad
				.axis(PCHLinearGradient.YAXIS)
				.size(_width, _height)
				;
			_backgroundGradientLWC.lightweightAdd(backgroundGrad);
		}
	}

	void renderCellGrid() {
		// instantiate cell unit, render to offscreen graphics
		// when finished rendering, lightweight add to lwc
		// when

		if (_cellGridLWC == null) {
			_cellGridLWC = new PCHLightweightCanvas(totalWidthOfGridSpan(), totalHeightOfGridSpan())
				.canvasAdditionRateLimit(numberOfGridColumns());
			add(_cellGridLWC);
		}

		if (_cellUnitRowReusableBuffer == null) {
			if (!_startedRenderingCellUnitRow) {
				println("here");
				int currentGridRow = 0;
				for (int currentCellRow = 0; currentCellRow < _numberOfCellsPerGridSide; currentCellRow++) {
					for (int currentCellColumn = 0; currentCellColumn < _numberOfCellsPerGridSide; currentCellColumn++) {
						for (int currentGridColumn = 0; currentGridColumn < numberOfGridColumns(); currentGridColumn++) {
							println("lightweight add");
							HRect cellRect = new HRect(_cellSize, _cellSize);
							cellRect
									.fill(0)
									.noStroke()
									.alpha(100);

							float offsetX =
									currentGridColumn * (widthOfGridColumn() + _gridGap)
								+ 	currentCellColumn * (_cellSize+_cellGap);
							float offsetY =
									currentGridRow * (heightOfGridRow() + _gridGap)
								+ 	currentCellRow * (_cellSize+_cellGap);

							cellRect.loc(offsetX, offsetY);
							_cellGridLWC.lightweightAdd(cellRect);
						}
					}
				}

				_startedRenderingCellUnitRow = true;
			}
			else {
				// if (!_cellGridLWC.hasLightweightChildren())
				// _cellUnitRowReusableBuffer = _cellGridLWC.graphicsCopy();
			}
		}

		// for (int currentGridColumn = 0; currentGridColumn < numberOfGridColumns(); currentGridColumn++) {
		// 	for (int currentGridRow = 0; currentGridRow < numberOfGridRows(); currentGridRow++) {
		// 		for (int currentCellColumn = 0; currentCellColumn < _numberOfCellsPerGridSide; currentCellColumn++) {
		// 			for (int currentCellRow = 0; currentCellRow < _numberOfCellsPerGridSide; currentCellRow++) {
		// 				HRect cellRect = new HRect(_cellSize, _cellSize);
		// 				cellRect
		// 						.fill(255)
		// 						.noStroke()
		// 						.alpha(100);

		// 				float offsetX =
		// 						currentGridColumn * (widthOfGridColumn() + _gridGap)
		// 					+ 	currentCellColumn * (_cellSize+_cellGap);
		// 				float offsetY =
		// 						currentGridRow * (heightOfGridRow() + _gridGap)
		// 					+ 	currentCellRow * (_cellSize+_cellGap);

		// 				cellRect.loc(offsetX, offsetY);
		// 				_lwc.lightweightAdd(cellRect);
		// 			}
		// 		}
		// 	}
		// }
	} // end -- renderCellGrid()

	// void renderTopGradients(PGraphics g, boolean usesZ, float drawX, float drawY, float currAlphaPc) {
	// 	int gradXInGridColumns = 0;
	// 	int gradYInGridRows = 0;
	// 	int gradWidthInGridColumns = 0;
	// 	int gradHeightInGridRows = 0;

	// 	int standardGradHeightInGridRows = 6;
	// 	int minGradWidthInGridColumns = 5;
	// 	int maxGradWidthInGridColumns = 8;

	// 	PCHLinearGradient grad = new PCHLinearGradient(_startColor, _endColor)
	// 		.axis(PCHLinearGradient.YAXIS);

	// 	while (gradYInGridRows < numberOfGridRows()) {
	// 		float inter = map(gradYInGridRows*heightOfGridRowAndGap(), 0, totalHeightOfGridSpan(), 0, 1);
	// 		color gradLerp = H.app().lerpColor(_startColor, _endColor, inter);
	// 		color gradLerpFaded = color(red(gradLerp), green(gradLerp), blue(gradLerp), random(25, 75));

	// 		gradHeightInGridRows = min(standardGradHeightInGridRows, numberOfGridRows() - gradYInGridRows);

	// 		while(gradXInGridColumns < numberOfGridColumns()) {
	// 			color gradStartColor = color(255, random(25, 75));
	// 			color gradEndColor = gradLerpFaded;

	// 			// randomly point gradient up or down
	// 			if (random(1) > .5) {
	// 				gradStartColor = gradLerpFaded;
	// 				gradEndColor = color(255, random(25, 75));
	// 			}

	// 			gradWidthInGridColumns = (numberOfGridColumns() - gradXInGridColumns) < maxGradWidthInGridColumns
	// 					? numberOfGridColumns() - gradXInGridColumns
	// 					: (int)random(minGradWidthInGridColumns, maxGradWidthInGridColumns);

	// 			grad
	// 				.startColor(gradStartColor)
	// 				.endColor(gradEndColor)
	// 				.loc(drawX + gradXInGridColumns*widthOfGridColumnAndGap(), drawY + gradYInGridRows*heightOfGridRowAndGap())
	// 				.size(widthOfGridColumnAndGap()*gradWidthInGridColumns - _gridGap, heightOfGridRowAndGap()*gradHeightInGridRows - _gridGap)
	// 				;

	// 			grad.paintAll(g, usesZ, currAlphaPc);

	// 			gradXInGridColumns += gradWidthInGridColumns;
	// 		}

	// 		gradXInGridColumns = 0;
	// 		gradYInGridRows += gradHeightInGridRows;
	// 	}
	// } // end -- renderTopGradients()

	// void renderAccentMarkSeries(HRect markerRect, int numberOfMarksInSeries, int markerGap, PGraphics g, boolean usesZ, float currAlphaPc) {
	// 	float markerWidth = markerRect.width();

	// 	float addonProbabilityThreshold = .8;
	// 	for (int i = 0; i < numberOfMarksInSeries; i++) {
	// 		// render base marker
	// 		markerRect.paintAll(g, usesZ, currAlphaPc);

	// 		// render addons
	// 		boolean addonIsAbove = (random(1) > .5) ? true : false;
	// 		if (random(1)>addonProbabilityThreshold) {
	// 			HRect addonRect = markerRect.createCopy();
	// 			float newHeight = markerRect.height()*random(.1,.9);
	// 			addonRect.height(newHeight);
	// 			if (addonIsAbove) {
	// 				addonRect.move(0, -1*newHeight);
	// 			}
	// 			else {
	// 				addonRect.move(0, markerRect.height());
	// 			}
	// 			addonRect.paintAll(g, usesZ, currAlphaPc);
	// 		}

	// 		markerRect.move(markerWidth+markerGap, 0);
	// 	}
	// }

	// public void renderAccentMarkSeriesPair(PGraphics g, boolean usesZ, float drawX, float drawY, float currAlphaPc) {
	// 	color markerColor = #4293D4;

	// 	int minNumberOfMarksInSeries = 2;
	// 	int maxNumberOfMarksInSeries = 10;

	// 	int numberOfMarksInSeries = floor(random(minNumberOfMarksInSeries, maxNumberOfMarksInSeries));

	// 	// Render left side
	// 	PVector seriesOrigin = pointCoordinatesForGridAndCellCoordinates(
	// 			(int)random(numberOfGridColumns()/2),
	// 			(int)random(numberOfGridRows()),
	// 			(int)random(_numberOfCellsPerGridSide),
	// 			(int)random(_numberOfCellsPerGridSide)
	// 			);

	// 	int dH = (int)random(0, 3);

	// 	int maxMarkerHeightInCellIncrements = 6;

	// 	int markerWidth = _cellSize + dH*_cellSize;
	// 	int markerHeight = (_cellSize+_cellGap)*(maxMarkerHeightInCellIncrements - dH);
	// 	int markerGap = _cellGap*2;
	// 	HRect markerRect = new HRect(markerWidth, markerHeight);
	// 	markerRect
	// 		.loc(drawX + seriesOrigin.x, drawY + seriesOrigin.y)
	// 		.fill(markerColor)
	// 		.noStroke();

	// 	// draw left half series
	// 	renderAccentMarkSeries(markerRect, numberOfMarksInSeries, markerGap, g, usesZ, currAlphaPc);

	// 	// draw mirror image series on right half
	// 	int seriesWidth = (markerWidth+markerGap)*numberOfMarksInSeries - markerGap;
	// 	markerRect.loc(drawX + totalWidthOfGridSpan() - seriesOrigin.x - seriesWidth, drawY + seriesOrigin.y);
	// 	renderAccentMarkSeries(markerRect, numberOfMarksInSeries, markerGap, g, usesZ, currAlphaPc);
	// }

	// public void renderAccentMarks(PGraphics g, boolean usesZ, float drawX, float drawY, float currAlphaPc) {
	// 	int baseNumberOfSeries = (int)(_width*_height/64000)*2;
	// 	for (int i = 0; i < baseNumberOfSeries+random(baseNumberOfSeries); i++) {
	// 		renderAccentMarkSeriesPair(g, usesZ, drawX, drawY, currAlphaPc);
	// 	}
	// }

	public void render() {
		if (!_needsRender) return;

		// println("rendering");

		// renderBackgroundGradient();
		renderCellGrid();

		// renderTopGradients(g, usesZ, drawX+gridOffsetX, drawY+(int)gridOffsetY, currAlphaPc);

		// renderAccentMarks(g, usesZ, drawX+gridOffsetX, drawY+gridOffsetY, currAlphaPc);
	} // end -- render()

	// Subclass methods
	//
	//

	public BlueCellGrid createCopy() {
		BlueCellGrid copy = new BlueCellGrid();
		copy.copyPropertiesFrom(this);
		return copy;
	}

	protected void onResize(float oldW, float oldH, float newW, float newH) {
		super.onResize(oldW, oldH, newW, newH);

		init();
	}

	public void draw( PGraphics g, boolean usesZ, float drawX, float drawY, float currAlphaPc ) { }

} // end -- class BlueCellGrid
