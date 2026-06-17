import "./Star.css";

const Star = ({ rating }) => {
    const fillPercentage = (rating / 5) * 100;

    return (
        <div className="star-wrapper">
            <div className="star">
                <div
                    className="star-fill"
                    style={{ width: `${fillPercentage}%` }}
                />
            </div>
            <span className="rating-text">{rating}</span>
        </div>
    );
};

export default Star;
